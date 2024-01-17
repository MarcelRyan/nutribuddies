import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/models/kids.dart';
import 'package:nutribuddies/screens/authenticate/add_kids.dart';
import 'package:nutribuddies/screens/edit_kids.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:nutribuddies/services/profile.dart';

class MyKids extends StatefulWidget {
  final List<Kids> listOfKids;
  const MyKids({super.key, required this.listOfKids});

  @override
  State<MyKids> createState() => _MyKidsState();
}

class _MyKidsState extends State<MyKids> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.07,
              MediaQuery.of(context).size.height * 0.05,
              MediaQuery.of(context).size.width * 0.07,
              MediaQuery.of(context).size.height * 0.02),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: black,
                    iconSize: 30.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'My Kids',
                        style: TextStyle(
                          color: black,
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddKids(
                                    fromSignUp: false,
                                    fromProfile: true,
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      backgroundColor: primary,
                      foregroundColor: white,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Add A Kid',
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
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Column(
                  children: List.generate(widget.listOfKids.length, (index) {
                Kids kid = widget.listOfKids[index];
                int age = ProfileService().calculateAge(kid.dateOfBirth);

                return Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.77,
                      decoration: BoxDecoration(
                          color: kid.gender == "Boy"
                              ? secondaryFixedDim
                              : tertiaryContainer,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              offset: const Offset(2, 4),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ]),
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.05,
                          MediaQuery.of(context).size.height * 0.01,
                          MediaQuery.of(context).size.width * 0.02,
                          MediaQuery.of(context).size.height * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FutureBuilder<String>(
                            future: DatabaseService(uid: '').getPhotoUrl(
                              kid.profilePictureUrl ?? '',
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                String photoUrl = snapshot.data ?? '';
                                return CircleAvatar(
                                  radius: MediaQuery.of(context).size.height *
                                      0.035,
                                  backgroundImage: NetworkImage(photoUrl),
                                );
                              }
                            },
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.025,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.025,
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    kid.displayName ?? '',
                                    style: const TextStyle(
                                      color: black,
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Age $age',
                                    style: TextStyle(
                                      color: kid.gender == "Boy"
                                          ? primary40
                                          : tertiary20,
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${kid.currentHeight} cm / ${kid.currentWeight} kg',
                                      style: const TextStyle(
                                        color: outline,
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditKids(
                                            kid: kid,
                                          )));
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    )
                  ],
                );
              }))
            ],
          ),
        ),
      ),
    );
  }
}
