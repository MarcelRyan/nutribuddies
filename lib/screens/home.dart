import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/services/auth.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        actions: [
          FloatingActionButton.extended(
            icon: const Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
              Fluttertoast.showToast(msg: "Signed Out");
            },
            label: const Text('logout'),
          )
        ],
      ),
    );
  }
}
