import 'package:fit_quest_final_project/data/models/run_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  group('RunData Class Tests', () {
    final exampleRunData = RunData(
      id: 'test123',
      distance: 5.0,
      duration: const Duration(seconds: 120),
      startTime: DateTime.parse("2023-12-01T10:00:00"),
      endTime: DateTime.parse("2023-12-01T10:20:00"),
      route: [const LatLng(0.0, 0.0), const LatLng(1.0, 1.0)],
      userId: 'user123',
    );



    // Test `fromFirestore` method with valid data
    test('fromFirestore should parse Firestore data correctly', () {
      final firestoreData = {
        'distance': 5.0,
        'duration': 120,
        'startTime': Timestamp.fromDate(DateTime.parse("2023-12-01T10:00:00")),
        'endTime': Timestamp.fromDate(DateTime.parse("2023-12-01T10:20:00")),
        'route': [
          {'latitude': 0.0, 'longitude': 0.0},
          {'latitude': 1.0, 'longitude': 1.0},
        ],
        'userId': 'user123',
      };

      final runData = RunData.fromFirestore('test123', firestoreData);

      expect(runData.id, equals('test123'));
      expect(runData.distance, equals(5.0));
      expect(runData.duration, equals(const Duration(seconds: 120)));
      expect(runData.startTime, equals(DateTime.parse("2023-12-01T10:00:00")));
      expect(runData.endTime, equals(DateTime.parse("2023-12-01T10:20:00")));
      expect(runData.route.length, equals(2));
      expect(runData.route[0], const LatLng(0.0, 0.0));
      expect(runData.route[1], const LatLng(1.0, 1.0));
      expect(runData.userId, equals('user123'));
    });

    // Test `fromFirestore` with invalid data
    test('fromFirestore should handle invalid date formats gracefully', () {
      final firestoreData = {
        'distance': 5.0,
        'duration': 120,
        'startTime': 'not_a_valid_date',
        'endTime': Timestamp.fromDate(DateTime.parse("2023-12-01T10:20:00")),
        'route': [
          {'latitude': 0.0, 'longitude': 0.0},
        ],
        'userId': 'user123',
      };

      expect(() => RunData.fromFirestore('test123', firestoreData), throwsA(isA<FormatException>()));
    });


    // Test with edge cases: Empty route list
    test('fromFirestore should handle empty route list gracefully', () {
      final firestoreData = {
        'distance': 0.0,
        'duration': 0,
        'startTime': Timestamp.fromDate(DateTime.parse("2023-12-01T10:00:00")),
        'endTime': Timestamp.fromDate(DateTime.parse("2023-12-01T10:00:10")),
        'route': [],
        'userId': 'user123',
      };

      final runData = RunData.fromFirestore('test123', firestoreData);

      expect(runData.route.isEmpty, isTrue);
      expect(runData.distance, equals(0.0));
    });

    // Test conversion to Map with empty fields
    test('toMap should handle zero distances and empty routes', () {
      final testRunData = RunData(
        id: 'test123',
        distance: 0.0,
        duration: const Duration(seconds: 0),
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        route: [],
        userId: 'user123',
      );

      final map = testRunData.toMap();
      expect(map['distance'], equals(0.0));
      expect(map['route'], isEmpty);
    });

    // Test timestamp duration equality
    test('Verify if duration is mapped correctly between seconds and `Duration`', () {
      final firestoreData = {
        'distance': 2.5,
        'duration': 150,
        'startTime': Timestamp.fromDate(DateTime.now()),
        'endTime': Timestamp.fromDate(DateTime.now().add(const Duration(seconds: 150))),
        'route': [],
        'userId': 'user321',
      };

      final runData = RunData.fromFirestore('abc', firestoreData);
      expect(runData.duration, equals(const Duration(seconds: 150)));
    });
  });
}
