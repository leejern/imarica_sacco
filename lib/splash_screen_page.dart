import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imarika_sacco_mobile_app/home_page.dart';
import 'package:imarika_sacco_mobile_app/log_in_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final user = Hive.box('user');

  @override
  void initState() {
    checkData();
    super.initState();
  }

  StatefulWidget checkData() {
    if (user.isEmpty) {
      return const LogInPage();
    } else {
      return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterSplashScreen.fadeIn(
      duration: const Duration(milliseconds: 5000),
      backgroundColor: Colors.white,
      childWidget: SizedBox(
        height: 200,
        width: 200,
        child: Image.asset("assets/images/app-logo.png"),
      ),
      nextScreen: checkData(),
    ));
  }
}
