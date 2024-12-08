import '../../data/models/run_data.dart';

/// Abstract class for repository actions
abstract class RunRepository {
  /// Fetches a list of runs for the given [userId].
  Future<List<RunData>> fetchRuns(String userId);

  /// Saves the [runData] for the given [userId].
  Future<void> saveRunData(RunData runData, String userId);
}
