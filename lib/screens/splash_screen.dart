import 'package:flutter/material.dart';
import 'package:nutribuddies/widgets/wrapper.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/screens/intro.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Intro1()),
      );
    });

    return Scaffold(
      backgroundColor: primaryFixedDim,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}
