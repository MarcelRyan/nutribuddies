import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object from firebase
  Users? _user(User? user) {
    if (user != null) {
      return Users(uid: user.uid);
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
      return _user(user);
    } catch (e) {
      return null;
    }
  }

  // register with email & password
  Future register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return _user(user);
    } catch (e) {
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
