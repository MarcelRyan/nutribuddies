import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coming Soon'),
      ),
      backgroundColor: background,
      body: Container(
        padding: const EdgeInsets.fromLTRB(40, 250, 40, 65),
        child: Column(
          children: [
            Image.asset('assets/coming_soon.png'),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "We're still cooking our app",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 0.06,
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            const Text(
              "New features coming soon!",
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: Color(0xFF74747E),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 0.09,
                letterSpacing: 0.50,
              ),
            ),
            const SizedBox(
              height: 90,
            ),
          ],
        ),
      ),
    );
  }
}
