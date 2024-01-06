import 'package:flutter/material.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/screens/authenticate/authenticate.dart';
import 'package:nutribuddies/screens/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);

    if (user == null) {
      return const Authenticate();
    } else {
      return Home();
    }
  }
}
