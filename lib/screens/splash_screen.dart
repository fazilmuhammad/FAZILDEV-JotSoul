import 'package:flutter/material.dart';
import 'package:jotsoul/screens/jornal_list_screen.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay before navigating to main screen
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const JournalListScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFCFBF8), // Match your background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image(
              image: AssetImage('assets/images/logo.png'), // Your splash logo
              width: 160,
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Image(
                image: AssetImage('assets/images/fazildev.png'), // Your bottom dev logo
                height: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
