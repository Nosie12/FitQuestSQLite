import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../data/models/run_data.dart';
import '../../../domain/repository/firestore_run_repository.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  // Fetch user's run data from Firestore and sort it by most recent first
  Future<List<RunData>> _fetchRuns() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final repository = FirestoreRunRepository();
    List<RunData> runs = await repository.fetchRuns(user.uid);

    // Sort runs by most recent startTime first
    runs.sort((a, b) => b.startTime.compareTo(a.startTime));
    return runs;
  }

  // Format duration to include minutes and seconds
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        backgroundColor: const Color(0xFF004D40),
      ),
      body: FutureBuilder<List<RunData>>(
        future: _fetchRuns(), // Fetch and sort data asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error loading runs.',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          final runs = snapshot.data ?? [];

          // If no runs exist, show a friendly message UI
          if (runs.isEmpty) {
            return _buildNoHistoryUI();
          }

          return _buildHistoryList(runs);
        },
      ),
    );
  }

  Widget _buildNoHistoryUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_run_outlined,
              color: Colors.grey,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              "No workout history found.",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Start running to add workouts to your history.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<RunData> runs) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      itemCount: runs.length,
      itemBuilder: (context, index) {
        final run = runs[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.directions_run, color: Colors.teal),
            title: Text(
              'Distance: ${run.distance.toStringAsFixed(2)} km',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Duration: ${_formatDuration(run.duration)}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  'Date: ${DateFormat.yMMMd().format(run.startTime)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.teal),
            onTap: () {
              // Handle tap if needed
            },
          ),
        );
      },
    );
  }
}
