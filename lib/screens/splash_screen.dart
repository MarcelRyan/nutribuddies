import 'package:flutter/material.dart';
import 'package:nutribuddies/widgets/wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Wrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF5F93A0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Image.asset('assets/logo.png'),
          ),
        ),
      ),
    );
  }
}
