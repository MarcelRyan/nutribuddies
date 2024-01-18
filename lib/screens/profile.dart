import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/models/kids.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/screens/authenticate/add_kids.dart';
import 'package:nutribuddies/screens/my_kids.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:nutribuddies/services/profile.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nutribuddies/screens/settings/settings.dart';

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
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.fromLTRB(
                          0,
                          MediaQuery.of(context).size.height * 0.02,
                          MediaQuery.of(context).size.width * 0.03,
                          0),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsPage(
                                          user: userData,
                                        )));
                          },
                          icon: const Icon(
                            Icons.settings,
                            size: 30,
                            color: white,
                          )),
                    ),
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
                    MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: FutureBuilder<List<Kids>>(
                    future: DatabaseService(uid: '').getKidsList(users.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No kids available');
                      } else {
                        List<Kids> kidsList = snapshot.data!;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
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
                                        letterSpacing: 0.15,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.07,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "(${kidsList.length})",
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: black,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.15,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyKids(
                                                  listOfKids: kidsList,
                                                )));
                                  },
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: const FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
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
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            KidsCarousel(kidsList: kidsList),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
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
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class KidsCarousel extends StatefulWidget {
  final List<Kids> kidsList;

  const KidsCarousel({Key? key, required this.kidsList}) : super(key: key);

  @override
  _KidsCarouselState createState() => _KidsCarouselState();
}

class _KidsCarouselState extends State<KidsCarousel> {
  int _currentKid = 0;
  final CarouselController _kidController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _kidController,
          options: CarouselOptions(
            aspectRatio: 8 / 6,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            initialPage: _currentKid,
            autoPlay: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentKid = index;
              });
            },
          ),
          items: widget.kidsList.map((Kids kid) {
            int age = ProfileService().calculateAge(kid.dateOfBirth);

            return Builder(
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.035,
                      MediaQuery.of(context).size.height * 0.03,
                      MediaQuery.of(context).size.width * 0.035,
                      MediaQuery.of(context).size.height * 0.02),
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: kid.gender == "Boy"
                        ? secondaryFixedDim
                        : tertiaryContainer,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: const Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              radius:
                                  MediaQuery.of(context).size.height * 0.055,
                              backgroundImage: NetworkImage(photoUrl),
                            );
                          }
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            kid.displayName ?? '',
                            style: const TextStyle(
                              color: black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "Age $age",
                            style: TextStyle(
                              color:
                                  kid.gender == "Boy" ? primary40 : tertiary20,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${kid.currentHeight} cm / ${kid.currentWeight} kg",
                            style: const TextStyle(
                              color: outline,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.kidsList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _kidController.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_currentKid == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
