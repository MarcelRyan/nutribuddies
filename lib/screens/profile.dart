import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users?>(context);

    return Scaffold(
      backgroundColor: background,
      body: FutureBuilder<Users>(
        future: DatabaseService(uid: users!.uid).getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('No user data available.');
          } else {
            Users userData = snapshot.data!;
            return Column(
              children: [
                Stack(
                  children: [
                    Image.asset('assets/Profile/Intersect.png'),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.04,
                      left: MediaQuery.of(context).size.width * 0.33,
                      height: MediaQuery.of(context).size.height * 0.17,
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: MediaQuery.of(context).size.height * 0.06,
                            backgroundImage: NetworkImage(
                              userData.profilePictureUrl ?? '',
                            ),
                          ),
                          const Spacer(),
                          Text(
                            userData.displayName ?? '',
                            style: const TextStyle(
                                color: onPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                    alignment: AlignmentDirectional.centerStart,
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.11,
                        MediaQuery.of(context).size.height * 0.02,
                        MediaQuery.of(context).size.width * 0.11,
                        MediaQuery.of(context).size.height * 0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "My Kids",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: 22,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.15),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.07,
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "(2)", //ntr ganti
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.15),
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                // ntr ganti
                              },
                              child: const Text(
                                'View all',
                                style: TextStyle(
                                  color: primary,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ))
              ],
            );
          }
        },
      ),
    );
  }
}
