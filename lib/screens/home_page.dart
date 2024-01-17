import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/models/kids.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/services/auth.dart';
import 'package:nutribuddies/screens/tracker.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class Article {
  DateTime date;
  String title;
  List<String> tags;
  String imagePath;

  Article(
      {required this.date,
      required this.title,
      required this.tags,
      required this.imagePath});
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Users? users = Provider.of<Users?>(context);

    List<Article> dummyData = [
      Article(
          date: DateTime(2023, 1, 11),
          title: "How To Teach Kids Healthy Eating Habits",
          tags: ["#KidsDiet", "#Parenting"],
          imagePath: "assets/Article/article1.png"),
      Article(
          date: DateTime(2023, 1, 12),
          title: "7 Day Easy Meal Plan for Your Kids",
          tags: ["#KidsDiet", "#Cooking"],
          imagePath: "assets/Article/article2.png"),
    ];

    String dateFormatter(DateTime date) {
      DateFormat formatter = DateFormat('MMMM d, y');

      String formattedDate = formatter.format(date);

      return formattedDate;
    }

    Future<List<Kids>> getUserKids(String parentUid) async {
      List<Kids> kids = [];

      QuerySnapshot querySnapshot =
          await DatabaseService(uid: '').kidsCollection.get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        DateTime dateTime = data['dateOfBirth'].toDate();
        Kids kid = Kids(
            bornWeight: data['bornWeight'] ?? '',
            currentHeight: data['currentHeight'] ?? '',
            currentWeight: data['currentWeight'] ?? '',
            dateOfBirth: dateTime,
            displayName: data['displayName'],
            gender: data['gender'],
            parentUid: data['parentUid'],
            profilePictureUrl: data['profilePictureUrl'],
            uid: data['uid']);

        if (kid.parentUid == parentUid) {
          kids.add(kid);
        }
      }

      return kids;
    }

    List<Kids> kidsData = [];

    Future<void> loadData(String parentUid) async {
      List<Kids> data = await getUserKids(parentUid);

      setState(() {
        kidsData = data;
      });
    }

    loadData("oj3pPxfiwsffe0FhnbYMKEBD1Oq1");

    return Scaffold(
      backgroundColor: background,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/Home/Intersect.png',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.02,
                  left: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi ${users?.displayName ?? "there"}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          height: 0.06,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.035,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.13,
                        decoration: BoxDecoration(
                          color: tertiaryContainer,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.015),
                        child: Row(children: [
                          Image.asset("assets/Intro/track1.png",
                              height: MediaQuery.of(context).size.height * 0.11,
                              width: MediaQuery.of(context).size.width * 0.25,
                              fit: BoxFit.fill),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03),
                          Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: RichText(
                                maxLines: 5,
                                softWrap: true,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Lets track ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                      letterSpacing: 0.15,
                                    ),
                                  ),
                                  if (kidsData.isEmpty)
                                    TextSpan(
                                      text: "your kids ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 1.4,
                                        letterSpacing: 0.15,
                                      ),
                                    ),
                                  if (!kidsData.isEmpty)
                                    for (int i = 0;
                                        i < kidsData.length;
                                        i++) ...[
                                      if (i == 0 && kidsData.length == 1)
                                        TextSpan(
                                            text:
                                                "${kidsData[i].displayName}'s",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                              height: 1.4,
                                            )),
                                      if (i == 0)
                                        TextSpan(
                                            text: "${kidsData[i].displayName}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                              height: 1.4,
                                            )),
                                      if (i == kidsData.length - 1 &&
                                          kidsData.length != 1)
                                        TextSpan(
                                            text:
                                                " and ${kidsData[i].displayName}'s ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                              height: 1.4,
                                            )),
                                      if (i != 0 || i != kidsData.length - 1)
                                        TextSpan(
                                            text:
                                                ", ${kidsData[i].displayName},",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                              height: 1.4,
                                            ))
                                    ],
                                  TextSpan(
                                    text: "nutrition today",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                      letterSpacing: 0.15,
                                    ),
                                  )
                                ]),
                              ))
                        ]),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.035,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Wrap(
                spacing: MediaQuery.of(context).size.width * 0.026,
                runSpacing: MediaQuery.of(context).size.height * 0.02,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                        color: primaryContainer,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.18,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                backgroundColor: primaryContainer,
                                foregroundColor: white,
                                elevation: 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/Home/track.png",
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.028,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.003,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "Track",
                                      style: TextStyle(
                                        color: Color(0xFF192231),
                                        fontSize: 10,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                        letterSpacing: 0.10,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                        color: primaryContainer,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.18,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                backgroundColor: primaryContainer,
                                foregroundColor: white,
                                elevation: 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/Home/menu.png",
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.028,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.003,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "Menu",
                                      style: TextStyle(
                                        color: Color(0xFF192231),
                                        fontSize: 10,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                        letterSpacing: 0.10,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                        color: primaryContainer,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.18,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                backgroundColor: primaryContainer,
                                foregroundColor: white,
                                elevation: 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/Home/article.png",
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.028,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.003,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "Article",
                                      style: TextStyle(
                                        color: Color(0xFF192231),
                                        fontSize: 10,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w900,
                                        height: 1,
                                        letterSpacing: 0.10,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                        color: primaryContainer,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.18,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                backgroundColor: primaryContainer,
                                foregroundColor: white,
                                elevation: 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/Home/forum.png",
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.028,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.003,
                                  ),
                                  Text(
                                    "Forum",
                                    style: TextStyle(
                                      color: Color(0xFF192231),
                                      fontSize: 8.5,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w900,
                                      height: 1,
                                      letterSpacing: 0.10,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                          color: Color(0xAFAFAFAF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/Home/consult.png",
                              width: MediaQuery.of(context).size.width * 0.08,
                              height: MediaQuery.of(context).size.height * 0.03,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.003,
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Consult",
                                style: TextStyle(
                                  color: Color(0xFF192231),
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w900,
                                  height: 1,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.075,
                        bottom: MediaQuery.of(context).size.height * 0.04,
                        child: Image.asset(
                          "assets/Home/premium.png",
                          scale: 1.2,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.345,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Featured Articles",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 1,
                            letterSpacing: 0.15,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "View All",
                          style: TextStyle(
                            color: Color(0xFF5674A7),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1,
                            letterSpacing: 0.50,
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: dummyData.map((record) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.015),
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02),
                          height: MediaQuery.of(context).size.height * 0.14,
                          decoration: BoxDecoration(
                              color: surfaceBright,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Image.asset(
                                record.imagePath,
                                width: MediaQuery.of(context).size.width * 0.2,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    Text(
                                      dateFormatter(record.date),
                                      style: TextStyle(
                                        color: Color(0xFF74747E),
                                        fontSize: 10,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                        letterSpacing: 0.50,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.012,
                                    ),
                                    Text(
                                      record.title,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        height: 1.2,
                                        letterSpacing: 0.15,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.013,
                                    ),
                                    Row(
                                      children: [
                                        for (int i = 0;
                                            i < record.tags.length;
                                            i++) ...[
                                          if (i == record.tags.length - 1)
                                            Text(
                                              record.tags[i],
                                              style: TextStyle(
                                                color: Color(0xFF5674A7),
                                                fontSize: 11,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                height: 1,
                                                letterSpacing: 0.50,
                                              ),
                                            ),
                                          if (i != record.tags.length - 1)
                                            Text(
                                              "${record.tags[i]} ",
                                              style: TextStyle(
                                                color: Color(0xFF5674A7),
                                                fontSize: 11,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                height: 1,
                                                letterSpacing: 0.50,
                                              ),
                                            ),
                                        ]
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
