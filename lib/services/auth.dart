// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nutribuddies/models/nutritions.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/meals.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object from firebase
  Users? _user(User? user) {
    List<String> topicInterest = [];
    if (user != null) {
      return Users(
          uid: user.uid,
          displayName: user.displayName,
          email: user.email,
          profilePictureUrl: user.photoURL,
          topicsInterest: topicInterest);
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

  // sign in with google
  Future<Object?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user!;
        return _user(user);
      } on FirebaseAuthException {
        // Error
      } catch (e) {
        // Error
      }
    }

    return user;
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  // register with email & password
  Future register(String email, String password, String displayName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      String defaultPhotoPath = 'default_profile.png';
      List<String> topicInterest = [];
      String defaultPhotoUrl =
          await DatabaseService(uid: user.uid).getPhotoUrl(defaultPhotoPath);
      await DatabaseService(uid: user.uid).updateUserData(
          uid: user.uid,
          displayName: displayName,
          email: email,
          profilePictureUrl: defaultPhotoUrl,
          topicInterest: topicInterest);
      return _user(user);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Invalid Email and/or Password: ${e.toString()}");
      return false;
    }
  }

  // sign out
  Future signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
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

  // is anonymous
  bool isAnonymous() {
    return _auth.currentUser!.isAnonymous;
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
        profilePictureUrl = 'boy.png';
      } else {
        profilePictureUrl = 'girl.png';
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
          calories: 0, proteins: 0, fiber: 0, fats: 0, carbs: 0, iron: 0);

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
          meals: meals);
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
      return false;
    }
  }
}
