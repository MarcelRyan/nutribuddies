import 'package:flutter/material.dart';
import 'package:nutribuddies/services/auth.dart';

class Register extends StatefulWidget {
  final Function isRegister;
  const Register({super.key, required this.isRegister});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
          backgroundColor: Colors.blue[400],
          elevation: 0.0,
          title: const Text('Sign up'),
          actions: [
            FloatingActionButton.extended(
              icon: const Icon(Icons.person),
              onPressed: () async {
                widget.isRegister();
              },
              label: const Text('Sign in'),
            )
          ]),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formkey,
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (val) => val!.isEmpty ? 'Enter an email' : null,
              onChanged: (val) {
                setState(() => email = val);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              validator: (val) => val!.length < 6
                  ? 'Enter a password with a minimum of 6 characters long'
                  : null,
              onChanged: (val) {
                setState(() => password = val);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  dynamic result = _auth.register(email, password);
                  if (result == null) {
                    setState(
                        () => error = 'Please provide valid email & password');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white),
              child: const Text('Register'),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            )
          ]),
        ),
      ),
    );
  }
}
