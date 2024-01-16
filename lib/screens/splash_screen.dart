import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/screens/intro.dart';
import 'package:nutribuddies/screens/home.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);

    Future.delayed(const Duration(seconds: 3), () {
      if (user != null) {
        // If the user is logged in, navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        // If the user is not logged in, navigate to the intro screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Intro1()),
        );
      }
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
