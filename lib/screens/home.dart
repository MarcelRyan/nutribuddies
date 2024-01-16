// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/services/auth.dart';
import 'package:nutribuddies/screens/tracker.dart';
import 'package:nutribuddies/widgets/wrapper.dart';
import 'package:nutribuddies/screens/article_interest.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final AuthService _auth = AuthService();

  late List<Widget> _tabs;
  late List<AppBar> _appBar;

  @override
  void initState() {
    super.initState();

    _tabs = [
      ComingSoon.buildComingSoonWidget(),
      const ArticleInterest(),
      const Tracker(),
      ComingSoon.buildComingSoonWidget(),
      ComingSoon.buildComingSoonWidget(),
    ];

    _appBar = [
      AppBar(
        title: const Text('NutriBuddies'),
        actions: [
          ElevatedButton(
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
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            ),
            child: const Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 8),
                Text('Logout'),
              ],
            ),
          )
        ],
      ),
      AppBar(
        title: const Text('Article'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut();
              Fluttertoast.showToast(msg: "Signed Out");
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            ),
            child: const Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 8),
                Text('Logout'),
              ],
            ),
          )
        ],
      ),
      AppBar(
        title: const Text('Tracker'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut();
              Fluttertoast.showToast(msg: "Signed Out");
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            ),
            child: const Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 8),
                Text('Logout'),
              ],
            ),
          )
        ],
      ),
      AppBar(
        title: const Text('Menu'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut();
              Fluttertoast.showToast(msg: "Signed Out");
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            ),
            child: const Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 8),
                Text('Logout'),
              ],
            ),
          )
        ],
      ),
      AppBar(
        title: const Text('Profile'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut();
              Fluttertoast.showToast(msg: "Signed Out");
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            ),
            child: const Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 8),
                Text('Logout'),
              ],
            ),
          )
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar[_currentIndex],
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFFF8F8F8),
        unselectedItemColor: Colors.black,
        selectedItemColor: primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Article',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class ComingSoon {
  static Widget buildComingSoonWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 250, 40, 65),
      child: Column(
        children: [
          Image.asset('assets/coming_soon.png'),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "We're still cooking our app",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 0.06,
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          const Text(
            "New features coming soon!",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              color: Color(0xFF74747E),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 0.09,
              letterSpacing: 0.50,
            ),
          ),
          const SizedBox(
            height: 90,
          ),
        ],
      ),
    );
  }
}
