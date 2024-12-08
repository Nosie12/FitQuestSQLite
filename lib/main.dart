import 'package:fit_quest_final_project/domain/repository/sqlite_database.dart';
import 'package:fit_quest_final_project/view/screens/auth/get_started.dart';
import 'package:fit_quest_final_project/view/screens/auth/login_screen.dart';
import 'package:fit_quest_final_project/view/screens/auth/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fit_quest_final_project/view/screens/home/home_screen.dart';
import 'package:fit_quest_final_project/view/screens/home/profile_view.dart';
import 'package:fit_quest_final_project/view/screens/profile/history.dart';
import 'package:fit_quest_final_project/view/screens/profile/premium.dart';
import 'package:fit_quest_final_project/view/screens/profile/thirty_day_challenge.dart';
import 'package:fit_quest_final_project/view/screens/run/run_history_screen.dart';
import 'package:fit_quest_final_project/view/screens/run/start_run_screen.dart';
import 'package:fit_quest_final_project/viewmodel/run/start_run_viewmodels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_quest_final_project/domain/repository/sqlite_repository.dart';
import 'package:fit_quest_final_project/domain/repository/firestore_run_repository.dart';
import 'package:fit_quest_final_project/domain/repository/sync_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'domain/repository/run_repo_manager.dart';
import 'firebase_options.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // For native platforms
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // For web
import 'package:flutter/foundation.dart'; // For kIsWeb check

// Fix: Ensure SQLite is initialized correctly for web and mobile support
void initSqfliteFfi() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}

/// Handle stream connection for changes properly
Stream<List<ConnectivityResult>> getConnectivityStream() {
  return Connectivity().onConnectivityChanged;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize SQLite support for both web and mobile platforms
  initSqfliteFfi();

  // Initialize database helpers
  final sqliteHelper = await initSQLiteHelper();
  final repositoryManager = await initializeRepositoryManager();

  runApp(MyApp(repositoryManager: repositoryManager));
}

/// Initialize SQLite database
Future<SQLiteHelper> initSQLiteHelper() async {
  final dbHelper = SQLiteHelper.instance;
  await dbHelper.database; // Ensure database is initialized
  return dbHelper;
}

/// Set up repository manager
Future<RunRepositoryManager> initializeRepositoryManager() async {
  final localRepository = SQLiteRunRepository(await SQLiteHelper.instance.database);
  final remoteRepository = FirestoreRunRepository();

  return RunRepositoryManager(
    localRepo: localRepository,
    remoteRepo: remoteRepository,
  );
}

class MyApp extends StatelessWidget {
  final RunRepositoryManager repositoryManager;

  const MyApp({Key? key, required this.repositoryManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StartRunViewModel>(
      create: (_) => StartRunViewModel(repositoryManager: repositoryManager),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FitQuest',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => GetStartedView(),
          '/signup': (context) => SignUpView(),
          '/login': (context) => LoginView(),
          '/home': (context) => HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/run': (context) => const StartRunScreen(),
          '/history': (context) => const HistoryScreen(),
          '/challenge': (context) => ImproveRunningPage(),
          '/premium': (context) => const PremiumScreen(),
        },
      ),
    );
  }
}
