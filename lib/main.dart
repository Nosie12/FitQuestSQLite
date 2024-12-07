import 'package:fit_quest_final_project/view/screens/auth/get_started.dart';
import 'package:fit_quest_final_project/view/screens/auth/login_screen.dart';
import 'package:fit_quest_final_project/view/screens/auth/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fit_quest_final_project/view/screens/home/home_screen.dart';
import 'package:fit_quest_final_project/view/screens/home/profile_view.dart';
import 'package:fit_quest_final_project/view/screens/profile/history.dart';
import 'package:fit_quest_final_project/view/screens/profile/premium.dart';
import 'package:fit_quest_final_project/view/screens/profile/thirty_day_challenge.dart';
import 'package:fit_quest_final_project/view/screens/run/start_run_screen.dart';
import 'package:fit_quest_final_project/viewmodel/run/start_run_viewmodels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StartRunViewModel>(
      create: (_) => StartRunViewModel(),
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
          '/profile':(context) => ProfileScreen(),
          '/run': (context) => StartRunScreen(),
          '/history': (context) => HistoryScreen(),
          '/challenge': (context) => ImproveRunningPage(),
          '/premium': (context) => PremiumScreen(),
        },
      ),
    );
  }
}
