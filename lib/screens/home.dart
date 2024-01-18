// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/screens/article_list.dart';
import 'package:nutribuddies/screens/home_page.dart';
import 'package:nutribuddies/screens/menu_recommendation.dart';
import 'package:nutribuddies/screens/profile.dart';
import 'package:nutribuddies/services/auth.dart';
import 'package:nutribuddies/screens/tracker.dart';
import 'package:nutribuddies/widgets/wrapper.dart';
import 'package:nutribuddies/screens/article_interest.dart';

class Home extends StatefulWidget {
  final int initialIndex;

  const Home({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(initialIndex);
}

class _HomeState extends State<Home> {
  int _currentIndex;
  final AuthService _auth = AuthService();

  late List<Widget> _tabs;
  late List<AppBar?> _appBar;

  _HomeState(this._currentIndex);

  @override
  void initState() {
    super.initState();

    _tabs = [
      HomePage(
        onIndexChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      _auth.isAnonymous() ? const ArticleList() : const ArticleInterest(),
      _auth.isAnonymous() ? const DirectLogin() : const Tracker(),
      _auth.isAnonymous() ? const DirectLogin() : const MenuRecommendation(),
      _auth.isAnonymous() ? const DirectLogin() : const Profile(),
    ];

    _appBar = [
      null,
      null,
      AppBar(
        title: const Text('Tracker'),
      ),
      AppBar(
        title: const Text('Menu'),
      ),
      AppBar(
        title: const Text('Profile'),
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

class DirectLogin extends StatelessWidget {
  const DirectLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();

    return Container(
      color: background,
      padding: const EdgeInsets.fromLTRB(40, 120, 40, 65),
      child: Column(
        children: [
          Image.asset('assets/direct_login.png'),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Oops...",
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
            "This feature is only available for NutriBuddies users. Please sign in first to your account.",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              color: Color(0xFF74747E),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 1,
              letterSpacing: 0.50,
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          ElevatedButton(
            onPressed: () async {
              await auth.signOut();
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
                borderRadius: BorderRadius.circular(100.0),
              ),
              minimumSize: Size(
                  double.infinity, MediaQuery.of(context).size.height * 0.06),
              backgroundColor: primary,
              foregroundColor: onPrimary,
            ),
            child: const Text(
              'Sign In',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
