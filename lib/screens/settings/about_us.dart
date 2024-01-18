import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.08,
              MediaQuery.of(context).size.height * 0.04,
              MediaQuery.of(context).size.width * 0.08,
              MediaQuery.of(context).size.height * 0.07),
          child: Column(
            children: [
              Image.asset('assets/logo.png'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              const Text(
                "NutriBuddies",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: black,
                    fontSize: 28,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Text(
                "Ensuring optimal child growth is an important element in sustainable living. However, malnutrition poses significant obstacles to children's physical and cognitive development, causing growth delays. Factors such as nutritional gaps, unbalanced eating patterns, and inadequate nutritional consumption are the main contributors to stunting in children.\n\nTo combat the problem of stunting in children, a comprehensive approach is needed, and the application of innovative nutrition can play a very important role. By utilizing technology, this solution can provide important support in meeting nutritional needs that are important for children's growth. This includes monitoring children's nutritional intake, providing personalized nutritional guidance and food recommendations, and providing easily accessible information for parents to ensure their children receive optimal nutrition throughout their growing years. Therefore, this technological support is expected to play an important role in reducing stunting and improving the overall well-being of children.",
                textAlign: TextAlign.justify,
                softWrap: true,
                style: TextStyle(
                  color: black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
