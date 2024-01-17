import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/services/auth.dart';
import 'package:nutribuddies/widgets/wrapper.dart';
import 'package:nutribuddies/services/settings.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final AuthService _auth = AuthService();
  final SettingsService _settings = SettingsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: black,
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        elevation: 0.0,
        backgroundColor: background,
        foregroundColor: black,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.1,
          MediaQuery.of(context).size.height * 0.025,
          MediaQuery.of(context).size.width * 0.1,
          MediaQuery.of(context).size.height * 0.025,
        ),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "About Your Account",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                onPressed: () {
                  // ntr ganti
                },
                icon: const Icon(
                  Icons.email,
                  color: primary,
                  size: 30,
                ),
                label: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Account Settings",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: primary,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                onPressed: () {
                  // ntr ganti
                },
                icon: const Icon(
                  Icons.account_circle,
                  color: primary,
                  size: 30,
                ),
                label: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Edit Profile",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: primary,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            const Align(
              alignment: Alignment.topLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "About NutriBuddies",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                onPressed: () {
                  // ntr ganti
                },
                icon: const Icon(
                  Icons.info,
                  color: primary,
                  size: 30,
                ),
                label: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "About Us",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: primary,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                onPressed: () {
                  // ntr ganti
                },
                icon: const Icon(
                  Icons.help,
                  color: primary,
                  size: 30,
                ),
                label: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Help",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: primary,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                onPressed: () {
                  _settings.redirectEmail();
                },
                icon: const Icon(
                  Icons.contact_mail_rounded,
                  color: primary,
                  size: 30,
                ),
                label: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Contact Us",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: primary,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Fluttertoast.showToast(msg: "Signed Out");
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Wrapper(
                                result: false,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(double.infinity,
                        MediaQuery.of(context).size.height * 0.055),
                    backgroundColor: error,
                    foregroundColor: onPrimary,
                    side: const BorderSide(color: outline, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Logout",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
