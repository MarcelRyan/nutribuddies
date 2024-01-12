import 'package:flutter/material.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/screens/authenticate/authenticate.dart';
import 'package:nutribuddies/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:nutribuddies/screens/authenticate/add_kids.dart';

// ignore: must_be_immutable
class Wrapper extends StatelessWidget {
  bool goToHome;
  bool goToAddKids;
  final bool result;
  Wrapper(
      {super.key,
      this.goToHome = false,
      required this.result,
      this.goToAddKids = false});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);

    if (user != null && result && goToHome) {
      goToHome = false;
      return Home();
    } else if (user != null && result && goToAddKids) {
      goToAddKids = false;
      return const AddKids();
    } else {
      return const Authenticate();
    }
  }
}
