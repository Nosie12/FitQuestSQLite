import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunData {
  final String id;
  final double distance;
  final Duration duration;
  final DateTime startTime;
  final DateTime endTime;
  final List<LatLng> route;
  final String userId;
  bool showTime;

  RunData({
    required this.id,
    required this.distance,
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.route,
    required this.userId,
    this.showTime = false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'distance': distance,
      'duration': duration.inSeconds,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'route': route.map((latLng) => {
        'latitude': latLng.latitude,
        'longitude': latLng.longitude,
      }).toList(),
      'userId': userId,
    };
  }

  factory RunData.fromFirestore(String id, Map<String, dynamic> data) {
    return RunData(
      id: id,
      distance: data['distance'] ?? 0.0,
      duration: Duration(seconds: data['duration'] ?? 0),
      startTime: _convertToDateTime(data['startTime']),
      endTime: _convertToDateTime(data['endTime']),
      route: (data['route'] as List<dynamic>).map((point) {
        return LatLng(
          point['latitude'] as double,
          point['longitude'] as double,
        );
      }).toList(),
      userId: data['userId'] ?? '',
    );
  }

  static DateTime _convertToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    } else {
      throw ArgumentError('Invalid date format: $value');
    }
  }
}
