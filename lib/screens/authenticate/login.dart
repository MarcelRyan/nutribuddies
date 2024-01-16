import 'package:flutter/material.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/screens/authenticate/forgot_password.dart';
import 'package:nutribuddies/screens/home.dart';
import 'package:nutribuddies/services/auth.dart';
import 'package:nutribuddies/constant/text_input_decoration.dart';
import 'package:nutribuddies/widgets/loading.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:provider/provider.dart';

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
    final user = Provider.of<Users?>(context);
    if (user != null) return const Home();

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
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.08,
                          MediaQuery.of(context).size.height * 0,
                          MediaQuery.of(context).size.width * 0.08,
                          MediaQuery.of(context).size.height * 0.07),
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
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
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
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
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
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
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
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
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
                                  minimumSize: Size(
                                      double.infinity,
                                      MediaQuery.of(context).size.height *
                                          0.06),
                                  backgroundColor: primary,
                                  foregroundColor: onPrimary,
                                ),
                                child: const Text(
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() => loading = true);
                              dynamic result = await _auth.signInWithGoogle();
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
                              minimumSize: Size(double.infinity,
                                  MediaQuery.of(context).size.height * 0.06),
                              backgroundColor: background,
                              foregroundColor: primary,
                              side: const BorderSide(color: outline, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/Login/icon.png'),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                const Text(
                                  'Login with Google',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
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
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
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
