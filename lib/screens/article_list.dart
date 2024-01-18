import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/models/article.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/screens/article_interest.dart';
import 'package:nutribuddies/screens/article_view.dart';
import 'package:nutribuddies/services/auth.dart';
import 'package:nutribuddies/services/debouncer.dart';
import 'package:provider/provider.dart';
import 'package:nutribuddies/services/database.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({Key? key}) : super(key: key);
  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> with TickerProviderStateMixin {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  late TabController _tabController;
  String? selectedTopic;
  final List<String> topics = ["All Topics", "Parenting", "Kids\' Nutrition", "Kids\' Lifestyle", "Kids\' Health", "Kids\' Diet", "Cooking"];
  List<Article> articles = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Article>> getListOfArticlesData(String searchQuery) async {
      List<Article> articlesList = [];

      QuerySnapshot querySnapshot =
        await DatabaseService(uid:'').articleCollection.get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;
        Article article = Article(
          uid: data['uid'] ?? '',
          title: data['title'],
          date: data['date'],
          topics: data['topics'] ?? [],
          imageUrl: data['imageUrl'],
          content: data['content'],
        );
        if (article.title.toLowerCase().contains(searchQuery.toLowerCase())) {
          articlesList.add(article);
        }
      }

      return articlesList;
    }

    Future<void> loadData(String searchQuery) async {
      List<Article> data = await getListOfArticlesData(searchQuery);
      setState(() {
        articles = data;
      });
    }

    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          shadowColor: Colors.transparent,
          toolbarHeight: 110,
          title: Container(
            height: MediaQuery.of(context).size.height * 0.065,
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                _debouncer.run(() {
                  loadData(value);
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search articles...",
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: outline, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: outline, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          // title: const Text (
          //     'Article',
          //     style: TextStyle(
          //       color: Colors.black,
          //       // fontSize: 32,
          //       fontFamily: 'Poppins',
          //       fontWeight: FontWeight.w500,
          //       letterSpacing: 0.10,
          //     )
          // ),
          bottom: TabBar(
            controller: _tabController,
            unselectedLabelColor: primary,
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: primary,
            ),
            tabs: [
              Tab(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: primary,
                          width: 1,
                        )
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'For You',
                        style: TextStyle(
                          // color: Colors.white,
                          // fontSize: 32,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.10,
                        ),
                      ),
                    )
                ),
              ),
              Tab(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: primary,
                          width: 1,
                        )
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Latest',
                        style: TextStyle(
                          // color: Colors.white,
                          // fontSize: 32,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.10,
                        ),
                      ),
                    )
                ),
              ),
              Container(
                decoration: (selectedTopic=='All Topics') ?
                BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: primary,
                    width: 1,
                  ),
                ) :
                BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: primary,
                    width: 1,
                  ),
                  color: primary,
                ),
                child: DropdownButton<String?>(
                  value: selectedTopic,
                  onChanged: (value) {
                    setState(() {
                      selectedTopic = value;
                    });
                  },
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.03,
                    right: MediaQuery.of(context).size.width * 0.015,
                  ),
                  underline: Container(),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: selectedTopic=='All Topics' ? primary : Colors.white,
                  ),
                  selectedItemBuilder: (BuildContext context) {
                    return topics
                        .map((e) => Text(
                      e,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedTopic=='All Topics' ? primary : Colors.white,
                      ),
                    ),
                    ).toList();
                  },
                  isExpanded: true,
                  alignment: Alignment.center,
                  items: topics
                      .map(
                        (e) => DropdownMenuItem(
                      child: Text(
                        e,
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: primary,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.10,
                        ),
                      ),
                      value: e,
                    ),
                  ).toList(),
                ),
              )
            ],),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ArticleContainersList(),
            ArticleContainersList(),
            ArticleContainersList(),
          ],)
    );
  }
}

class ArticleContainersList extends StatefulWidget {
  @override
  State<ArticleContainersList> createState() => _ArticleContainersListState();
}

class _ArticleContainersListState extends State<ArticleContainersList>{

  @override
  Widget build(BuildContext context){
    final Users? users = Provider.of<Users?>(context);
    final AuthService _auth = AuthService();

    return Scaffold(
      backgroundColor: background,
      body: Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width*0.08,
            right: MediaQuery.of(context).size.width*0.08,
        ),
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.025),
        child: ListView.builder(
          itemCount: 10, // Specify the number of times you want to loop
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ArticleView())
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.77,
                decoration: BoxDecoration(
                  color: surfaceBright,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      offset: const Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05,
                  MediaQuery.of(context).size.height * 0.01,
                  MediaQuery.of(context).size.width * 0.02,
                  MediaQuery.of(context).size.height * 0.01,
                ),
                margin: EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.height * 0.125,
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.01,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset('assets/Article/article_topic_6_cooking.png'),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.025,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date",
                          style: const TextStyle(
                            color: outline,
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Judul",
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                        Text(
                          "#Topics",
                          style: const TextStyle(
                            color: primary,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        )
      ),
    );
  }
}