import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/run_data.dart';

class FirestoreRunRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch runs from Firestore
  Future<List<RunData>> fetchRuns(String userId) async {
    try {
      final mainCollection = _firestore.collection('runs');
      final querySnapshot = await mainCollection
          .where('userId', isEqualTo: userId) // Filter runs by userId
          .get();

      List<RunData> runs = [];

      for (var document in querySnapshot.docs) {
        final data = document.data();
        runs.add(RunData.fromFirestore(document.id, data));
      }

      return runs;
    } catch (e) {
      print('Error fetching runs from Firestore: $e');
      return [];
    }
  }

  // Save run data to Firestore
  Future<void> saveRunData(RunData runData, String userId) async {
    try {
      final runRef = _firestore.collection('runs').doc();

      // Save the run data to Firestore
      await runRef.set({
        'userId': userId,
        'route': runData.route.map((latLng) => {
          'latitude': latLng.latitude,
          'longitude': latLng.longitude
        }).toList(),
        'distance': runData.distance,
        'duration': runData.duration.inSeconds,
        'startTime': runData.startTime.toIso8601String(),
        'endTime': runData.endTime.toIso8601String(),
      });
    } catch (e) {
      print("Error saving run data: $e");
      throw Exception('Error saving run data');
    }
  }
}
