import 'package:flutter/material.dart';
import 'package:nutribuddies/screens/authenticate/forgot_password.dart';
import 'package:nutribuddies/services/auth.dart';
import 'package:nutribuddies/constant/text_input_decoration.dart';
import 'package:nutribuddies/widgets/loading.dart';
import 'package:nutribuddies/constant/colors.dart';

import '../../widgets/wrapper.dart';

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
            backgroundColor: background,
            body: Column(
              children: [
                Image.asset('assets/Login/Group1(1).png'),
                ClipRect(
                  child: Transform.translate(
                    offset: const Offset(0, -0),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 52),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Login",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: black,
                                fontSize: 32,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400),
                          ),
                          Form(
                            key: _formkey,
                            child: Column(children: [
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Email'),
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
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Password'),
                                obscureText: true,
                                validator: (val) => val!.length < 6
                                    ? 'Enter a password with a minimum of 6 characters long'
                                    : null,
                                onChanged: (val) {
                                  setState(() => password = val);
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword()),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: primary,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    setState(() => loading = true);
                                    dynamic result =
                                        await _auth.signIn(email, password);
                                    if (result == null) {
                                      setState(() => loading = false);
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Wrapper(
                                                  result: true,
                                                  goToHome: true,
                                                )),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  minimumSize: const Size(double.infinity, 48),
                                  backgroundColor: primary,
                                  foregroundColor: onPrimary,
                                ),
                                child: const Text(
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() => loading = true);
                              dynamic result =
                                  await AuthService.signInWithGoogle();
                              if (result == null) {
                                setState(() => loading = false);
                              } else {
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Wrapper(
                                            result: true,
                                            goToHome: true,
                                          )),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              minimumSize: const Size(double.infinity, 48),
                              backgroundColor: background,
                              foregroundColor: primary,
                              side: const BorderSide(color: outline, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/Login/icon.png'),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'Login with Google',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don’t have an account?',
                                  style: TextStyle(
                                    color: neutral70,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.isLogin();
                                  },
                                  child: const Text(
                                    'Sign up',
                                    style: TextStyle(
                                      color: primary,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
