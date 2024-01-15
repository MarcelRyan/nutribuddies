import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/screens/intro.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Intro1()),
      );
    });

    return Scaffold(
      backgroundColor: onPrimaryFixed,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.04),
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}
