import 'package:flutter/material.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/screens/authenticate/authenticate.dart';
import 'package:nutribuddies/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:nutribuddies/screens/authenticate/add_kids.dart';

class Wrapper extends StatelessWidget {
  final bool goToHome;
  final bool result;
  const Wrapper({super.key, this.goToHome = false, required this.result});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);

    if (user != null && result && goToHome) {
      return Home();
    } else if (user != null && result) {
      return const AddKids();
    } else {
      return const Authenticate();
    }
  }
}
