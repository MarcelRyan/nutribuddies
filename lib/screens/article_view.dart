import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({Key? key}) : super(key: key);
  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        toolbarHeight: 110,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Article',
          style: TextStyle(
            color: black,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        elevation: 0.0,
        backgroundColor: background,
        foregroundColor: black,
      ),
      body: Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width*0.08,
            right: MediaQuery.of(context).size.width*0.08,
            bottom: MediaQuery.of(context).size.width*0.07
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width*0.125,
                    bottom: MediaQuery.of(context).size.height * 0.025
                ),
                child: Text(
                  'How To Teach Kids Healthy Eating Habits',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.025),
                child: Text(
                  'January 11th, 2023',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: outline,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.025),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Image.asset('assets/Article/dummy_article.png'),
              ),
              Container(
                child: Text(
                  'You’ve probably heard the old adage, “You are what you eat.” While your child isn’t going to literally morph into a fruit salad or a loaf of garlic bread, the food choices they make (and that you make for them) have a very literal impact on their bodies.\n\nPoor eating habits in childhood can follow your kids well into adulthood, causing health issues and difficult relationships with food. By teaching kids about food that’s good for their health when they’re little, you can set them up for a lifetime of wellness.\n\n\"It\'s never too soon to start teaching kids good eating habits,\" says pediatric dietitian Diana Schnee, MS, RD, CSP, LD.\n\nFood serves a lot of purposes. It can be tasty, fun and culturally important, and eating with loved ones provides opportunities for bonding and togetherness. But food is also science. And kids need healthy foods — full of the right vitamins and minerals — in the right amounts, to help them grow.\n\n\"Food is the first type of medicine,\" adds pediatric cardiologist Christina Fink, MD. \"Kids need good nutrition to live, grow and be healthy. But inadequate or improper types of nutrition can lead to childhood obesity, high cholesterol, high blood pressure, prediabetes and further issues once in adulthood.\"\n\nThese tips can help you teach your kids eating habits that will equip them for a healthy future and a positive relationship with food.',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}