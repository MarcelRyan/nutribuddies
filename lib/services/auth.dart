import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/models/nutritions.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:uuid/uuid.dart';

import '../models/meals.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object from firebase
  Users? _user(User? user) {
    if (user != null) {
      return Users(
          uid: user.uid,
          displayName: user.displayName,
          email: user.email,
          profilePictureUrl: user.photoURL);
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
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
      return null;
    }
  }

  // sign in with email & password
  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return _user(user);
    } catch (e) {
      Fluttertoast.showToast(msg: "Wrong email and/or password");
      return null;
    }
  }

  // register with email & password
  Future register(String email, String password, String displayName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      String defaultPhotoPath = 'default_user.jpg';
      String defaultPhotoUrl =
          await DatabaseService(uid: user.uid).getPhotoUrl(defaultPhotoPath);
      await DatabaseService(uid: user.uid).updateUserData(
          uid: user.uid,
          displayName: displayName,
          email: email,
          profilePicutreUrl: defaultPhotoUrl);
      return _user(user);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Invalid Email and/or Password: ${e.toString()}");
      return false;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
      return null;
    }
  }

  // reset password
  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
      return null;
    }
  }

  // register kid
  Future registerKid(
      String parentUid,
      String displayName,
      DateTime dateOfBirth,
      String gender,
      double currentHeight,
      double currentWeight,
      double bornWeight) async {
    try {
      // generate kid uid
      final String kidsUid = const Uuid().v4();

      // check if kid uid unique
      bool flagKid =
          await DatabaseService(uid: parentUid).isKidsUidUnique(kidsUid);
      while (!flagKid) {
        flagKid =
            await DatabaseService(uid: parentUid).isKidsUidUnique(kidsUid);
      }

      String profilePictureUrl = '';
      if (gender == 'Boy') {
        profilePictureUrl = 'default_user.jpg'; //ntr ganti
      } else {
        profilePictureUrl = 'default_user.jpg'; //ntr ganti
      }

      // generate tracker uid
      final String trackerUid = const Uuid().v4();

      // check if uid unique
      bool flagTracker =
          await DatabaseService(uid: parentUid).isTrackerUidUnique(trackerUid);
      while (!flagTracker) {
        flagTracker = await DatabaseService(uid: parentUid)
            .isTrackerUidUnique(trackerUid);
      }

      Nutritions currentNutritions = Nutritions(
          calories: 0, proteins: 0, fiber: 0, fats: 0, carbs: 0, sugar: 0);
      Nutritions maxNutritions = Nutritions(
          calories: 100,
          proteins: 100,
          fiber: 100,
          fats: 100,
          carbs: 100,
          sugar: 100);
      List<Meals> meals = [];

      await DatabaseService(uid: parentUid).updateKidData(
          kidsUid: kidsUid,
          displayName: displayName,
          dateOfBirth: dateOfBirth,
          gender: gender,
          currentHeight: currentHeight,
          currentWeight: currentWeight,
          bornWeight: bornWeight,
          profilePictureUrl: profilePictureUrl);
      await DatabaseService(uid: parentUid).updateTrackerData(
          trackerUid: trackerUid,
          kidUid: kidsUid,
          date: DateTime.now(),
          currentNutritions: currentNutritions,
          maxNutritions: maxNutritions,
          meals: meals);
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
      return false;
    }
  }
}
