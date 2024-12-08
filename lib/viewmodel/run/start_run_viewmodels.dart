import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/models/run_data.dart';
import '../../domain/repository/run_repo_manager.dart';
import '../../domain/repository/sqlite_repository.dart';
import '../../domain/repository/firestore_run_repository.dart';

// Enum representing the state of a run
enum RunState { idle, running, stopped }

// Enum representing possible errors in tracking
enum RunTrackingError {
  permissionDenied,
  locationServiceDisabled,
  unknownError,
}

// ViewModel managing the run logic
class StartRunViewModel extends ChangeNotifier {
  Position? _currentPosition;
  LatLng? _lastPosition;
  List<LatLng> _polylineCoordinates = [];
  double _distance = 0.0;

  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {}; // Add markers for user position
  StreamSubscription<Position>? _positionStream;

  RunState _runState = RunState.idle;

  // Time tracking variables
  DateTime? _startTime;
  Duration _totalDuration = Duration.zero;
  Timer? _durationTimer;

  final RunRepositoryManager _repositoryManager;

  StartRunViewModel({required RunRepositoryManager repositoryManager})
      : _repositoryManager = repositoryManager;

  // Getters
  Position? get currentPosition => _currentPosition;
  List<LatLng> get polylineCoordinates => _polylineCoordinates;
  Set<Polyline> get polylines => _polylines;
  Set<Marker> get markers => _markers; // Access the markers
  double get distance => _distance;
  RunState get runState => _runState;

  String get formattedDuration {
    final hours = _totalDuration.inHours;
    final minutes = _totalDuration.inMinutes % 60;
    final seconds = _totalDuration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  double get avgPace {
    if (_distance == 0 || _totalDuration.inMinutes == 0) return 0;
    return _totalDuration.inMinutes / _distance;
  }

  // Start Run Logic
  Future<RunTrackingResult> startRun() async {
    try {
      if (_runState == RunState.running) {
        return RunTrackingResult(success: false);
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return RunTrackingResult(
          success: false,
          error: RunTrackingError.locationServiceDisabled,
        );
      }

      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        return RunTrackingResult(
          success: false,
          error: RunTrackingError.permissionDenied,
        );
      }

      _runState = RunState.running;
      _startTime = DateTime.now();
      _startDurationTracking();
      notifyListeners();

      // Start listening to location updates
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 2,
        ),
      ).listen((Position position) {
        // Log the accuracy for debugging purposes
        print("Position update received with accuracy: ${position.accuracy} meters");

      _currentPosition = position;

        final newLatLng = LatLng(position.latitude, position.longitude);

        if (_lastPosition != null) {
          _calculateDistance(_lastPosition!, newLatLng);
        }

        _lastPosition = newLatLng;

        _polylineCoordinates.add(newLatLng);
        _updatePolyline();
        _updateMarker(newLatLng);
        notifyListeners();
      });

      return RunTrackingResult(success: true);
    } catch (e) {
      return RunTrackingResult(
        success: false,
        error: RunTrackingError.unknownError,
      );
    }
  }

  void stopRun() {
    _runState = RunState.stopped;
    _positionStream?.cancel();
    _durationTimer?.cancel();
    notifyListeners();
  }

  void updateDuration(Duration newDuration) {
    _totalDuration = newDuration;
    notifyListeners();
  }

  void resetRun() {
    _runState = RunState.idle;
    _currentPosition = null;
    _lastPosition = null;
    _polylineCoordinates = [];
    _polylines.clear();
    _markers.clear();
    _distance = 0.0;
    _totalDuration = Duration.zero;
    _startTime = null;
    _durationTimer?.cancel();
    notifyListeners();
  }

  void _updatePolyline() {
    _polylines.clear();
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: _polylineCoordinates,
        color: Colors.green,
        width: 5,
      ),
    );
  }

  void _updateMarker(LatLng position) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('user_position'),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
  }

  void _startDurationTracking() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _totalDuration = DateTime.now().difference(_startTime!);
      notifyListeners();
    });
  }

  Future<void> saveRunData(String userId) async {
    if (_runState != RunState.stopped) return;

    final runData = RunData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      route: _polylineCoordinates,
      distance: _distance,
      duration: _totalDuration,
      startTime: _startTime!,
      endTime: DateTime.now(),
      userId: userId,
    );

    try {
      await _repositoryManager.saveRunData(runData, userId);
    } catch (e) {
      print("Error saving run data: $e");
    }
  }

  Future<bool> _handleLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      return requested != LocationPermission.denied &&
          requested != LocationPermission.deniedForever;
    }
    return permission != LocationPermission.deniedForever;
  }

  void _calculateDistance(LatLng start, LatLng end) {
    final distanceMeters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );

    if (distanceMeters >= 1) {
      _distance += distanceMeters / 1000;
      notifyListeners();
    }
  }
}

class RunTrackingResult {
  final bool success;
  final RunTrackingError? error;

  RunTrackingResult({required this.success, this.error});
}
