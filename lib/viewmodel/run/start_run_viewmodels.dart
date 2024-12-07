import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/models/run_data.dart';
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

  final FirestoreRunRepository _firestoreRunRepository = FirestoreRunRepository();

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
          distanceFilter: 2, // Minimum distance change to trigger updates
        ),
      ).listen((Position position) {
        if (position.accuracy > 50) {
          // Ignore updates with accuracy worse than 50 meters
          print("Skipping position update due to low accuracy: ${position.accuracy} meters");
          return;
        }

        print('New Position: ${position.latitude}, ${position.longitude}');
        _currentPosition = position;

        final newLatLng = LatLng(position.latitude, position.longitude);

        if (_lastPosition != null) {
          print('Calculating distance from $_lastPosition to $newLatLng');
          _calculateDistance(_lastPosition!, newLatLng);
        }

        _lastPosition = newLatLng;
        _updatePolyline();
        _updateMarker(newLatLng); // Update user position marker
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

  // Stop Run Logic
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

  // Reset Run (optional)
  void resetRun() {
    _runState = RunState.idle;
    _currentPosition = null;
    _lastPosition = null;
    _polylineCoordinates = [];
    _polylines.clear();
    _markers.clear(); // Clear markers on reset
    _distance = 0.0;
    _totalDuration = Duration.zero;
    _startTime = null;
    _durationTimer?.cancel();
    notifyListeners();
  }

  // Update polyline set
  void _updatePolyline() {
    _polylines.clear();
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: _polylineCoordinates,
        color: Colors.green, // Green color for route
        width: 5,
      ),
    );
  }

  // Update user marker position
  void _updateMarker(LatLng position) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('user_position'),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // Green arrow icon
        rotation: 0, // Rotation based on direction can be added if needed
      ),
    );
  }

  // Start duration tracking
  void _startDurationTracking() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _totalDuration = DateTime.now().difference(_startTime!);
      notifyListeners();
    });
  }

  // Handle location permission
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

    if (distanceMeters > 100) {
      print('Ignoring unrealistic jump of $distanceMeters meters');
      return;
    }

    if (distanceMeters >= 1) {
      _distance += distanceMeters / 1000;
      print('Updated Distance: $_distance km');
      print('Updated Avg Pace: $avgPace min/km');
      notifyListeners();
    }
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
      await _firestoreRunRepository.saveRunData(runData, userId);
    } catch (e) {
      print("Error saving run data: $e");
    }
  }
}

class RunTrackingResult {
  final bool success;
  final RunTrackingError? error;

  RunTrackingResult({required this.success, this.error});
}
