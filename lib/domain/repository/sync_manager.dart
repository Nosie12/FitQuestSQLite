import 'package:fit_quest_final_project/domain/repository/sqlite_repository.dart';
import './firestore_run_repository.dart';

/// Synchronization Manager
class SyncManager {
  final FirestoreRunRepository remoteRepo;
  final SQLiteRunRepository localRepo;

  SyncManager(this.remoteRepo, this.localRepo);

  Future<void> syncRuns(String userId) async {
    try {
      final unsyncedRuns = await localRepo.fetchRuns(userId);
      for (final run in unsyncedRuns) {
        try {
          await remoteRepo.saveRunData(run, userId);
          await localRepo.markAsSynced(run.id);
          print('Synced ${run.id}');
        } catch (e) {
          print('Error syncing run: ${run.id}');
        }
      }

      final remoteRuns = await remoteRepo.fetchRuns(userId);
      for (final run in remoteRuns) {
        await localRepo.saveRunData(run, userId);
      }
    } catch (e) {
      print('Error during sync process: $e');
    }
  }
}
