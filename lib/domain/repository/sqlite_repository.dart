import 'package:sqflite/sqflite.dart';
import '../../data/models/run_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './run_repository.dart';

/// SQLite Repository Implementation
class SQLiteRunRepository implements RunRepository {
  final Database _db;

  SQLiteRunRepository(this._db);

  @override
  Future<List<RunData>> fetchRuns(String userId) async {
    final result = await _db.query(
      'runs',
      where: 'userId = ? AND isSynced = 0',
      whereArgs: [userId],
    );

    return result.map((row) {
      return RunData(
        id: row['id'] as String,
        distance: row['distance'] as double,
        duration: Duration(seconds: row['duration'] as int),
        startTime: DateTime.parse(row['startTime'] as String),
        endTime: DateTime.parse(row['endTime'] as String),
        route: (row['route'] as String)
            .split(';')
            .map((point) {
          final coords = point.split(',');
          return LatLng(double.parse(coords[0]), double.parse(coords[1]));
        }).toList(),
        userId: row['userId'] as String,
      );
    }).toList();
  }

  @override
  Future<void> saveRunData(RunData runData, String userId) async {
    final routeString = runData.route
        .map((latLng) => '${latLng.latitude},${latLng.longitude}')
        .join(';');

    await _db.insert('runs', {
      'id': runData.id,
      'distance': runData.distance,
      'duration': runData.duration.inSeconds,
      'startTime': runData.startTime.toIso8601String(),
      'endTime': runData.endTime.toIso8601String(),
      'route': routeString,
      'userId': userId,
      'isSynced': 0,
    });
  }

  Future<void> markAsSynced(String runId) async {
    await _db.update(
      'runs',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [runId],
    );
  }
}
