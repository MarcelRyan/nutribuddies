import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/models/tracker.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object from firebase
  Users? _user(User? user) {
    if (user != null) {
      return Users(uid: user.uid, name: user.displayName, email: user.email);
    } else {
      return null;
    }
  }

  // change user stream
  Stream<Users?> get user {
    return _auth.authStateChanges().map(_user);
  }

  // sign in anonymous
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      return _user(user);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error");
      return null;
    }
  }

  // sign in with email & password
  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      Nutritions currentNutritions =
          Nutritions(protein: 0, fiber: 0, carbohydrate: 0);
      Nutritions maxNutritions =
          Nutritions(protein: 100, fiber: 100, carbohydrate: 100);
      await DatabaseService(uid: user.uid)
          .updateTrackerData(currentNutritions, maxNutritions, DateTime.now());
      return _user(user);
    } catch (e) {
      Fluttertoast.showToast(msg: "Wrong email and/or password");
      return null;
    }
  }

  // register with email & password
  Future register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      Nutritions currentNutritions =
          Nutritions(protein: 0, fiber: 0, carbohydrate: 0);
      Nutritions maxNutritions =
          Nutritions(protein: 100, fiber: 100, carbohydrate: 100);
      await DatabaseService(uid: user.uid)
          .updateTrackerData(currentNutritions, maxNutritions, DateTime.now());
      await DatabaseService(uid: user.uid).updateUserData('tester', email);
      return _user(user);
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid Email and/or Password");
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      Fluttertoast.showToast(msg: "Error");
      return null;
    }
  }
}
