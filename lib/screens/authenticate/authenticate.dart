import 'package:flutter/material.dart';
import 'package:nutribuddies/screens/authenticate/login.dart';
import 'package:nutribuddies/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isSignIn = false;

  void toggleView() {
    setState(() => isSignIn = !isSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (isSignIn) {
      return Login(isLogin: toggleView);
    } else {
      return Register(isRegister: toggleView);
    }
  }
}
