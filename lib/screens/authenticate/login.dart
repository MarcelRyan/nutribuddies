import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/services/auth.dart';
import 'package:nutribuddies/constant/text_input_decoration.dart';
import 'package:nutribuddies/widgets/loading.dart';

class Login extends StatefulWidget {
  final Function isLogin;
  const Login({super.key, required this.isLogin});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.blue[100],
            appBar: AppBar(
              backgroundColor: Colors.blue[400],
              elevation: 0.0,
              title: const Text('Sign in'),
              actions: [
                FloatingActionButton.extended(
                  icon: const Icon(Icons.person),
                  onPressed: () async {
                    widget.isLogin();
                  },
                  label: const Text('Register'),
                )
              ],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Column(
                children: [
                  Form(
                    key: _formkey,
                    child: Column(children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
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
                            setState(() => loading = true);
                            dynamic result =
                                await _auth.signIn(email, password);
                            if (result == null) {
                              setState(() => loading = false);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white),
                        child: const Text('Sign in'),
                      ),
                    ]),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => loading = true);
                      dynamic result = await _auth.signInAnon();
                      if (result == null) {
                        setState(() => loading = false);
                        Fluttertoast.showToast(msg: 'Error');
                      } else {
                        Fluttertoast.showToast(msg: 'Signed in');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white),
                    child: const Text('Sign in anonymous'),
                  ),
                ],
              ),
            ),
          );
  }
}
