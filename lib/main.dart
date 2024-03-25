import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imarika_sacco_mobile_app/firebase_options.dart';
import 'package:imarika_sacco_mobile_app/home_page.dart';
import 'package:imarika_sacco_mobile_app/log_in_page.dart';
import 'package:imarika_sacco_mobile_app/splash_screen_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  await Hive.initFlutter();
  await Hive.openBox('user');
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final user = Hive.box('user');

  StatefulWidget checkData() {
    if (user.isEmpty) {
      return const LogInPage();
    } else {
      return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreenPage(),
      title: 'Imarika Sacco',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 231, 230, 233),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 231, 230, 233),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(103, 58, 183, 1)),
        useMaterial3: true,
      ),
    );
  }
}
