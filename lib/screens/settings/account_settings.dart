import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nutribuddies/constant/text_input_decoration.dart';
import 'package:nutribuddies/widgets/loading.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/services/auth.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  String email = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: background,
            appBar: AppBar(backgroundColor: background),
            body: Container(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.08,
                  MediaQuery.of(context).size.height * 0,
                  MediaQuery.of(context).size.width * 0.08,
                  MediaQuery.of(context).size.height * 0.07),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Change Email?",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: black,
                          fontSize: 32,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    const Text(
                      "Please enter the email address you'd like to change to.",
                      textAlign: TextAlign.justify,
                      softWrap: true,
                      style: TextStyle(
                        color: black,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: 0.25,
                      ),
                    ),
                    Form(
                      key: _formkey,
                      child: Column(children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth.resetPassword(email);
                              if (result == null) {
                                setState(() => loading = false);
                              } else {
                                // ntr ganti
                                // ignore: use_build_context_synchronously
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => const CheckEmail()),
                                // );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            minimumSize: Size(double.infinity,
                                MediaQuery.of(context).size.height * 0.06),
                            backgroundColor: primary,
                            foregroundColor: onPrimary,
                          ),
                          child: const Text(
                            'Send',
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
                  ]),
            ),
          );
  }
}
