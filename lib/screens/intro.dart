import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/widgets/wrapper.dart';

import '../services/auth.dart';
import '../widgets/loading.dart';

class Intro1 extends StatelessWidget {
  const Intro1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Container(
        padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.height * 0.04,
            MediaQuery.of(context).size.height * 0.2,
            MediaQuery.of(context).size.height * 0.04,
            MediaQuery.of(context).size.height * 0.07),
        child: Column(
          children: [
            Image.asset('assets/Intro/track1.png'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Image.asset('assets/Intro/ProgressStatus.png'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            const Text(
              "Track your kid's meals",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: black,
                  fontSize: 28,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const Text(
              "Monitor your kids' meals and nutrition for a foundation of lifelong well-being!",
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: black,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.5,
                letterSpacing: 0.25,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Intro2()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: primary,
                foregroundColor: onPrimary,
              ),
              child: const Text(
                'Next',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Intro2 extends StatelessWidget {
  const Intro2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Container(
        padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.height * 0.05,
            MediaQuery.of(context).size.height * 0.2,
            MediaQuery.of(context).size.height * 0.05,
            MediaQuery.of(context).size.height * 0.07),
        child: Column(
          children: [
            Image.asset('assets/Intro/menu_recommendations1.png'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Image.asset('assets/Intro/ProgressStatus(1).png'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            const Text(
              "Discover kids’ menu recommendations",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: black,
                  fontSize: 28,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const Text(
              "Explore new personalized meals and recipes just for your kids!",
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: black,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.5,
                letterSpacing: 0.25,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.18,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Intro3()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: primary,
                foregroundColor: onPrimary,
              ),
              child: const Text(
                'Next',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Intro3 extends StatelessWidget {
  const Intro3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Container(
        padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.height * 0.05,
            MediaQuery.of(context).size.height * 0.2,
            MediaQuery.of(context).size.height * 0.05,
            MediaQuery.of(context).size.height * 0.07),
        child: Column(
          children: [
            Image.asset('assets/Intro/articles_2(1).png'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Image.asset('assets/Intro/ProgressStatus(2).png'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            const Text(
              "Read articles",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: black,
                  fontSize: 28,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const Text(
              "Unlock the secrets to raising healthy kids with expert tips and insights!",
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: black,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.5,
                letterSpacing: 0.25,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Intro4()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: primary,
                foregroundColor: onPrimary,
              ),
              child: const Text(
                'Next',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Intro4 extends StatelessWidget {
  const Intro4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Container(
        padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.height * 0.05,
            MediaQuery.of(context).size.height * 0.2,
            MediaQuery.of(context).size.height * 0.05,
            MediaQuery.of(context).size.height * 0.07),
        child: Column(
          children: [
            Image.asset('assets/Intro/Frame2.png'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Image.asset('assets/Intro/ProgressStatus(3).png'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            const Text(
              "Discuss and ask questions",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: black,
                  fontSize: 28,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const Text(
              "Jump into our community forum to share your stories and gain fresh insights!",
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: black,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.5,
                letterSpacing: 0.25,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Intro5()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: primary,
                foregroundColor: onPrimary,
              ),
              child: const Text(
                'Next',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Intro5 extends StatefulWidget {
  const Intro5({super.key});

  @override
  State<Intro5> createState() => _Intro5State();
}

class _Intro5State extends State<Intro5> {
  final AuthService _auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: background,
            body: Container(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.height * 0.05,
                  MediaQuery.of(context).size.height * 0.2,
                  MediaQuery.of(context).size.height * 0.05,
                  MediaQuery.of(context).size.height * 0.07),
              child: Column(
                children: [
                  Image.asset('assets/Intro/consult1.png'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Image.asset('assets/Intro/ProgressStatus(4).png'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  const Text(
                    "Get expert advice",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: black,
                        fontSize: 28,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  const Text(
                    "Consult with trusted doctors and nutritionists for healthier kids!",
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: 0.25,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.13,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Wrapper(
                                  result: false,
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: primary,
                      foregroundColor: onPrimary,
                    ),
                    child: const Text(
                      'Get Started',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => loading = true);
                      dynamic result = await _auth.signInAnon();
                      if (result == null) {
                        setState(() => loading = false);
                        Fluttertoast.showToast(msg: 'Error');
                      } else {
                        Fluttertoast.showToast(msg: 'Signed in');
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Wrapper(
                                    goToHome: true,
                                    result: true,
                                  )),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: background,
                      foregroundColor: primary,
                      side: const BorderSide(color: outline, width: 1),
                    ),
                    child: const Text(
                      'Continue as a Guest',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
