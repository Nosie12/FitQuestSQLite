import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../viewmodel/run/start_run_viewmodels.dart';

class StartRunScreen extends StatefulWidget {
  const StartRunScreen({Key? key}) : super(key: key);

  @override
  _StartRunScreenState createState() => _StartRunScreenState();
}

class _StartRunScreenState extends State<StartRunScreen> {
  GoogleMapController? _mapController;
  double _currentZoom = 14.0;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StartRunViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Run'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            viewModel.stopRun();
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Map Section
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: viewModel.currentPosition != null
                  ? LatLng(viewModel.currentPosition!.latitude, viewModel.currentPosition!.longitude)
                  : const LatLng(0.0, 0.0),
              zoom: _currentZoom,
            ),
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            polylines: viewModel.polylines,
            markers: viewModel.markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),
          // Zoom UI Buttons
          Positioned(
            top: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  mini: true,
                  onPressed: _zoomIn,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: Colors.black),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  mini: true,
                  onPressed: _zoomOut,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.remove, color: Colors.black),
                ),
              ],
            ),
          ),
          // Stats Section at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF002A10),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(
                          'Distance', '${viewModel.distance.toStringAsFixed(2)} km'),
                      _buildStatCard('Time', viewModel.formattedDuration),
                      _buildStatCard(
                          'Pace', '${viewModel.avgPace.toStringAsFixed(2)} min/km'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (viewModel.runState == RunState.idle ||
                          viewModel.runState == RunState.stopped) {
                        _startRun(context, viewModel);
                      } else if (viewModel.runState == RunState.running) {
                        _stopRun(context, viewModel);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: viewModel.runState == RunState.running
                          ? Colors.black
                          : const Color(0xFF81A55D),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                        viewModel.runState == RunState.running ? 'Stop' : 'Start'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _zoomIn() {
    if (_mapController != null && _currentZoom < 20) {
      setState(() {
        _currentZoom++;
        _mapController!.moveCamera(CameraUpdate.zoomTo(_currentZoom));
      });
    }
  }

  void _zoomOut() {
    if (_mapController != null && _currentZoom > 5) {
      setState(() {
        _currentZoom--;
        _mapController!.moveCamera(CameraUpdate.zoomTo(_currentZoom));
      });
    }
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _startRun(BuildContext context, StartRunViewModel viewModel) async {
    final result = await viewModel.startRun();
    if (!result.success) {
      String errorMessage = 'Unable to start run';
      switch (result.error) {
        case RunTrackingError.permissionDenied:
          errorMessage = 'Permission denied';
          break;
        case RunTrackingError.locationServiceDisabled:
          errorMessage = 'Location services disabled';
          break;
        default:
          errorMessage = 'Unknown error';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _stopRun(BuildContext context, StartRunViewModel viewModel) {
    viewModel.stopRun();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to save run data'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Run Completed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Distance: ${viewModel.distance.toStringAsFixed(2)} km'),
            Text('Duration: ${viewModel.formattedDuration}'),
            Text('Avg Pace: ${viewModel.avgPace.toStringAsFixed(2)} min/km'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await viewModel.saveRunData(userId);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              viewModel.resetRun();
              Navigator.of(context).pop();
            },
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }
}
