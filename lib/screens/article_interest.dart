import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/screens/article_list.dart';
import 'package:nutribuddies/models/article_interest.dart';
import 'package:provider/provider.dart';

class ArticleInterest extends StatefulWidget {
  const ArticleInterest({Key? key}) : super(key: key);
  @override
  State<ArticleInterest> createState() => _ArticleInterestState();
}

class _ArticleInterestState extends State<ArticleInterest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        body: Container(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.08,
                MediaQuery.of(context).size.width * 0.07,
                MediaQuery.of(context).size.width * 0.08,
                MediaQuery.of(context).size.width * 0.07),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                    width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.topLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Articles",
                      textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.10,
                        )
                    )
                  )
                ),
                Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.005,
                      bottom: MediaQuery.of(context).size.height * 0.005,
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.topLeft,
                    child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("What topics are you interested in?",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: neutral40,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.10,
                            )))),
                Expanded(child: InterestContent()),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ArticleList()));
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
                    'Next',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                )
              ],
            )));
  }
}

class InterestContent extends StatefulWidget {
  const InterestContent({super.key});

  @override
  State<InterestContent> createState() => _InterestContentState();
}

class _InterestContentState extends State<InterestContent> {
  final List<ArticleTopicInterest> interests = [
    ArticleTopicInterest(
      topic: 'Parenting',
      topicImage: 'assets/Article/article_topic_1_parenting.png',
      isInterested: false,
    ),
    ArticleTopicInterest(
      topic: 'Kids\' Nutrition',
      topicImage: 'assets/Article/article_topic_2_kids_nutrition.png',
      isInterested: false,
    ),
    ArticleTopicInterest(
      topic: 'Kids\' Lifestyle',
      topicImage: 'assets/Article/article_topic_3_kids_lifestyle.png',
      isInterested: false,
    ),
    ArticleTopicInterest(
      topic: 'Kids\' Health',
      topicImage: 'assets/Article/article_topic_4_kids_health.png',
      isInterested: false,
    ),
    ArticleTopicInterest(
      topic: 'Kids\' Diet',
      topicImage: 'assets/Article/article_topic_5_kids_diet.png',
      isInterested: false,
    ),
    ArticleTopicInterest(
      topic: 'Cooking',
      topicImage: 'assets/Article/article_topic_6_cooking.png',
      isInterested: false,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final Users? users = Provider.of<Users?>(context);

    return Scaffold(
      backgroundColor: background,
      body: GridView.count(
        crossAxisCount: 2,
        children: interests.map((topic) {
          return Center(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: InkWell(
                  splashColor: background,
                  onTap: () {
                    // Navigate to the category page
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.height * 0.4,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Image.asset(topic.topicImage),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 13,
                        right: 13,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          // color: Colors.black.withOpacity(0.6),
                          child: Text(
                            topic.topic,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              shadows: <Shadow>[
                                Shadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 8.0,
                                    color: Colors.black.withOpacity(0.15)),
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 3.0,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 8,
                          right: 13,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment(0, 0),
                                colors: [
                                  Colors.white.withOpacity(0.55),
                                  Colors.white.withOpacity(0),
                                ],
                                radius: 0.5,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.25),
                                  spreadRadius: 0.5,
                                  blurRadius: 25,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Checkbox(
                              value: topic.isInterested,
                              activeColor: primary,
                              splashRadius: 0.5,
                              onChanged: (value) {
                                setState(() {
                                  topic.isInterested = value!;
                                });
                              },
                            ),
                          ))
                    ],
                  )),
            ),
          );
        }).toList(),
      ),
    );
  }
}
