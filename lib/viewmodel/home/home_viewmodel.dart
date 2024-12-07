import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/run_data.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double weeklyGoal = 0.0;
  double progressPercentage = 0.0;
  double weeklyProgress = 0.0;
  double remainingDistance = 0.0;

  List<RunData> recentRuns = []; // Stores the 10 recent runs
  List<RunData> allRuns = []; // Stores all runs
  bool isLoading = false;

  HomeViewModel() {
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      final User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        // Fetch user data and runs
        await fetchUserData(userId);
        await fetchRecentUserRuns(userId);
      } else {
        print('No user is currently logged in.');
      }
    } catch (error) {
      print('Error initializing user data: $error');
    }
  }

  Future<void> fetchUserData(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        weeklyGoal = (data['weeklyGoal'] ?? 0).toDouble();
        weeklyProgress = (data['weeklyProgress'] ?? 0).toDouble();
        remainingDistance = weeklyGoal - weeklyProgress;
        progressPercentage = weeklyGoal == 0 ? 0 : (weeklyProgress / weeklyGoal) * 100;
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRecentUserRuns(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await _firestore
          .collection('runs')
          .where('userId', isEqualTo: userId)
          .orderBy('startTime', descending: true)
          .limit(10)
          .get();

      List<RunData> fetchedRuns = querySnapshot.docs.map((doc) {
        return RunData.fromFirestore(doc.id, doc.data());
      }).toList();

      recentRuns = fetchedRuns;

      // Recalculate weekly progress based on the latest runs
      _updateWeeklyProgress();
    } catch (e) {
      print('Error fetching user runs: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  bool goalSet = false;

  void setWeeklyGoal(double goal) async {
    final user = _auth.currentUser;
    if (user != null) {
      weeklyGoal = goal;
      remainingDistance = weeklyGoal - weeklyProgress;
      progressPercentage = weeklyGoal == 0 ? 0 : (weeklyProgress / weeklyGoal) * 100;
      goalSet = true; // Set goal as true

      try {
        await _firestore.collection('users').doc(user.uid).set({
          'weeklyGoal': goal,
          'weeklyProgress': weeklyProgress,
        });

        notifyListeners();
      } catch (e) {
        print('Error saving weekly goal: $e');
      }
    }
  }


  void addNewRun(RunData run) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('runs').add({
          'userId': user.uid,
          'startTime': run.startTime,
          'endTime': run.endTime,
          'distance': run.distance,
          'duration': run.duration.inSeconds,
        });

        recentRuns.insert(0, run);

        // Update weekly progress after saving the new run
        weeklyProgress += run.distance;
        remainingDistance = weeklyGoal - weeklyProgress;
        progressPercentage = weeklyGoal == 0 ? 0 : (weeklyProgress / weeklyGoal) * 100;

        await _firestore.collection('users').doc(user.uid).update({
          'weeklyProgress': weeklyProgress,
        });

        notifyListeners();
      }
    } catch (e) {
      print('Error saving new run: $e');
    }
  }

  void _updateWeeklyProgress() {
    // Aggregate recent runs' distances for weekly progress calculation
    weeklyProgress = recentRuns.fold(0.0, (sum, run) => sum + run.distance);
    remainingDistance = weeklyGoal - weeklyProgress;
    progressPercentage = weeklyGoal == 0 ? 0 : (weeklyProgress / weeklyGoal) * 100;
    notifyListeners();
  }
}
