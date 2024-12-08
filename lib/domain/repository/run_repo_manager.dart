import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/models/run_data.dart';
import './run_repository.dart';

/** Manages synchronization between local and remote repositories.
    Handles data fetch and save operations based on network connectivity.
    Determines whether to use local or remote repositories depending on online status. **/
/// Repository Manager
class RunRepositoryManager implements RunRepository {
  final RunRepository localRepo;
  final RunRepository remoteRepo;

  RunRepositoryManager({required this.localRepo, required this.remoteRepo});

  Future<bool> _isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<List<RunData>> fetchRuns(String userId) async {
    if (await _isOnline()) {
      final remoteRuns = await remoteRepo.fetchRuns(userId);
      for (final run in remoteRuns) {
        await localRepo.saveRunData(run, userId);
      }
      return remoteRuns;
    } else {
      return await localRepo.fetchRuns(userId);
    }
  }

  @override
  Future<void> saveRunData(RunData runData, String userId) async {
    await localRepo.saveRunData(runData, userId);
    if (await _isOnline()) {
      await remoteRepo.saveRunData(runData, userId);
    }
  }
}
