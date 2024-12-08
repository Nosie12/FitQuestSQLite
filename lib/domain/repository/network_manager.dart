import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fit_quest_final_project/domain/repository/sync_manager.dart';
import 'package:flutter/material.dart';

/** Manages network connectivity changes and triggers data sync.
    Monitors network status and communicates with the provided SyncManager.
    Listens for connectivity changes to determine online/offline status. **/

class NetworkManager {
  final SyncManager syncManager;
  late Stream<ConnectivityResult> connectivityStream;

  NetworkManager(this.syncManager) {
    // Flatten the list into individual ConnectivityResult events
    connectivityStream = Connectivity().onConnectivityChanged.expand(
          (results) => results.isEmpty ? [ConnectivityResult.none] : results,
    );
    listen();
  }

  void listen() {
    connectivityStream.listen((connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        print("Connected. Triggering sync...");
        syncManager.syncRuns('userId'); // Replace 'userId' with your logic.
      } else {
        print("Disconnected.");
      }
    });
  }
}
