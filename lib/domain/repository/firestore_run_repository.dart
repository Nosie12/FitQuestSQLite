import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/run_data.dart';
import './run_repository.dart';

/** Repository for managing running data with Firestore.
    Handles fetching runs by user ID and saving new run data.
    Interfaces with Firestore's `runs` collection. **/

/// Firestore Repository Implementation
class FirestoreRunRepository implements RunRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<RunData>> fetchRuns(String userId) async {
    try {
      final mainCollection = _firestore.collection('runs');
      final querySnapshot = await mainCollection
          .where('userId', isEqualTo: userId)
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

  @override
  Future<void> saveRunData(RunData runData, String userId) async {
    try {
      final runRef = _firestore.collection('runs').doc();
      await runRef.set(runData.toMap());
    } catch (e) {
      print("Error saving run data: $e");
      throw Exception('Error saving run data');
    }
  }
}
