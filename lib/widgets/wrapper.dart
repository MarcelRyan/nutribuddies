import 'package:flutter/material.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/screens/authenticate/authenticate.dart';
import 'package:nutribuddies/screens/home.dart';
import 'package:nutribuddies/services/auth.dart';
import 'package:nutribuddies/services/food_tracker.dart';
import 'package:nutribuddies/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:nutribuddies/screens/authenticate/add_kids.dart';

// ignore: must_be_immutable
class Wrapper extends StatelessWidget {
  bool goToHome;
  bool goToAddKids;
  bool goToProfile;

  final bool result;
  final AuthService _auth = AuthService();

  Wrapper(
      {super.key,
      this.goToHome = false,
      this.goToProfile = false,
      required this.result,
      this.goToAddKids = false});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);

    if (user != null && result && goToHome) {
      goToHome = false;
      if (goToProfile) {
        goToProfile = false;
        return const Home(initialIndex: 4);
      }
      return const Home();
    } else if (user != null && result && goToAddKids) {
      goToAddKids = false;
      return AddKids();
    } else if (user != null && !_auth.isAnonymous()) {
      return FutureBuilder(
        future: checkIfUserHasKids(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return const Home();
            } else {
              return AddKids();
            }
          } else {
            return const Loading();
          }
        },
      );
    } else {
      return const Authenticate();
    }
  }

  Future<bool> checkIfUserHasKids(BuildContext context) async {
    try {
      final Users? users = Provider.of<Users?>(context);
      final FoodTrackerService foodTracker = FoodTrackerService();
      final firstKid = await foodTracker.getFirstKid(users!.uid);
      return firstKid?.uid != "";
    } catch (error) {
      return false;
    }
  }
}
