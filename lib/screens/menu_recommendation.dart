import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/models/kids.dart';
import 'package:nutribuddies/models/menu_recommendation.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/screens/error_screen.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:nutribuddies/services/menu_recommendation.dart';
import 'package:nutribuddies/widgets/loading.dart';
import 'package:provider/provider.dart';

class MenuRecommendation extends StatefulWidget {
  const MenuRecommendation({Key? key}) : super(key: key);

  @override
  State<MenuRecommendation> createState() => _MenuRecommendationState();
}

class _MenuRecommendationState extends State<MenuRecommendation> {
  late String kidUid;
  bool loading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeKidUid();
  }

  Future<void> _initializeKidUid() async {
    // Get user
    final Users? users = Provider.of<Users?>(context, listen: false);

    // Initialize menu recommendation service
    final MenuRecommendationService menuRecommendation =
        MenuRecommendationService();

    // Set loading state
    setState(() => loading = true);

    // Get first kid from user
    final firstKid = await menuRecommendation.getFirstKid(users!.uid);

    // Check if get first kid error or not
    if (firstKid == null) {
      setState(() => isError = true);
      setState(() => loading = false);
      return;
    } else {
      setState(() {
        kidUid = firstKid.uid;
      });
    }

    // End initialize Uid first kid
    setState(() => loading = false);
    setState(() => isError = false);
  }

  Future<bool> checkAnswers(BuildContext context) async {
    try {
      // Get user
      final Users? users = Provider.of<Users?>(context, listen: false);

      // Initialize menu recommendation service
      final MenuRecommendationService menuRecommendation =
          MenuRecommendationService();

      final answers = await menuRecommendation.getAnswers(kidUid, users!.uid);

      return answers?.answers["status"] != "failed";
    } catch (error) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users?>(context);
    final MenuRecommendationService menuRecommendation =
        MenuRecommendationService();

    return loading
        ? const Loading()
        : isError
            ? ErrorReloadWidget(
                errorMessage: 'An error occurred. Please try again.',
                onReloadPressed: () {
                  _initializeKidUid();
                },
              )
            : Scaffold(
                backgroundColor: background,
                body: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      Stack(
                        children: [
                          Image.asset('assets/Tracker/Rectangle_12308.png'),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.04,
                            left: MediaQuery.of(context).size.width * 0.32,
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.38,
                            child: FutureBuilder<List<Kids>>(
                              future: DatabaseService(uid: '')
                                  .getKidsList(users!.uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Text('No kids available');
                                } else {
                                  List<Kids> kidsList = snapshot.data!;
                                  Future<Kids?> firstKidFuture =
                                      menuRecommendation.getFirstKid(users.uid);
                                  String? selectedValue;

                                  return FutureBuilder<Kids?>(
                                      future: firstKidFuture,
                                      builder: (context, kidSnapshot) {
                                        if (kidSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (kidSnapshot.hasError) {
                                          return Text(
                                              'Error: ${kidSnapshot.error}');
                                        } else {
                                          Kids? firstKid = kidSnapshot.data;
                                          selectedValue = firstKid?.uid;
                                          return DropdownButtonFormField<
                                              String>(
                                            value: selectedValue,
                                            onChanged: (String? newValue) {
                                              updateKidUid(newValue ?? '');
                                              setState(() {
                                                selectedValue = newValue;
                                              });
                                            },
                                            items: kidsList
                                                .map<DropdownMenuItem<String>>(
                                              (Kids kid) {
                                                return DropdownMenuItem<String>(
                                                  value: kid.uid,
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.24,
                                                    child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          kid.displayName
                                                              as String,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        )),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: primaryContainer,
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.04,
                                                      0,
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.03,
                                                      0),
                                              border: InputBorder.none,
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16)),
                                                borderSide: BorderSide(
                                                    width: 1, color: outline),
                                              ),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16)),
                                                borderSide: BorderSide(
                                                    width: 1, color: outline),
                                              ),
                                            ),
                                            style: const TextStyle(
                                              color: onPrimaryContainer,
                                            ),
                                            icon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.black),
                                            elevation: 16,
                                            dropdownColor: primaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          );
                                        }
                                      });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      FutureBuilder(
                        future: checkAnswers(context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.data == true) {
                              return const MenuRecommendationList();
                            } else {
                              return QnaPage(saveAnswers: saveAnswer);
                            }
                          } else {
                            return const Loading();
                          }
                        },
                      )
                    ])));
  }

  void updateKidUid(String newKidUid) {
    setState(() {
      kidUid = newKidUid;
    });
  }

  Future<void> saveAnswer(Map<String, dynamic> selectedAnswers) async {
    // Get user
    final Users? users = Provider.of<Users?>(context, listen: false);

    // Save QnARecommendation
    final MenuRecommendationService menuRecommendation =
        MenuRecommendationService();

    try {
      setState(() {
        loading = true;
      });
      await menuRecommendation.saveAnswers(kidUid, users!.uid, selectedAnswers);
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }
}

class QnaPage extends StatefulWidget {
  final Future<void> Function(Map<String, dynamic>) saveAnswers;
  const QnaPage({super.key, required this.saveAnswers});

  @override
  State<QnaPage> createState() => _QnaPageState();
}

class _QnaPageState extends State<QnaPage> {
  List<String> questions = [
    "What is your child's favorite protein source?",
    "Which type of pasta does your child prefer?",
    "What is your child's preferred vegetable?",
    "Choose a preferred side dish:",
    "What is your child's favorite fruit?",
    "Which type of sandwich does your child like?",
    "Pick a preferred dairy option:",
    "What's your child's favorite snack?",
    "Select a preferred dessert:",
    "What is your child's preferred beverage?",
  ];

  List<List<String>> options = [
    ['Chicken', 'Fish', 'Tofu'],
    ['Spaghetti', 'Macaroni', 'Penne'],
    ['Broccoli', 'Carrots', 'Peas'],
    ['Mashed Potatoes', 'Rice', 'French Fries'],
    ['Apple', 'Banana', 'Grapes'],
    ['Peanut Butter & Jelly', 'Turkey & Cheese', 'Veggie Wrap'],
    ['Cheese', 'Yogurt', 'Milk'],
    ['Popcorn', 'Cheese Sticks', 'Fruit Salad'],
    ['Chocolate Pudding', 'Fruit Popsicle', 'Cupcake'],
    ['Apple Juice', 'Water', 'Strawberry Milk'],
  ];

  Map<String, dynamic> selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Discover Your Child's Perfect Plate: Menu Q&A!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return QnaCard(
                question: questions[index],
                options: options[index],
                selectedAnswer: selectedAnswers[questions[index]] ?? '',
                onChanged: (selectedOption) {
                  setState(() {
                    selectedAnswers[questions[index]] = selectedOption;
                  });
                },
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              surfaceTintColor: surfaceBright,
              foregroundColor: primary,
            ),
            onPressed: () async {
              // Validate that every question is answered
              bool allQuestionsAnswered = questions.every((question) =>
                  selectedAnswers.containsKey(question) &&
                  selectedAnswers[question]!.isNotEmpty);

              if (allQuestionsAnswered) {
                try {
                  await widget.saveAnswers(selectedAnswers);
                } catch (e) {
                  Fluttertoast.showToast(msg: "Error saving answers!");
                }
              } else {
                Fluttertoast.showToast(msg: "Please answer all questions!");
              }
            },
            child: const Text("Let's Go!",
                style: TextStyle(
                  fontFamily: 'Poppins',
                )),
          ),
        ],
      ),
    );
  }
}

class QnaCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final String selectedAnswer;
  final ValueChanged<String>? onChanged;

  const QnaCard({
    super.key,
    required this.question,
    required this.options,
    required this.selectedAnswer,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: surfaceBright,
      surfaceTintColor: surfaceBright,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: options.map((option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Radio(
                        value: option,
                        groupValue: selectedAnswer,
                        onChanged: (value) {
                          onChanged?.call(value as String);
                        },
                      ),
                      Text(option,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                          )),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuRecommendationList extends StatefulWidget {
  const MenuRecommendationList({Key? key}) : super(key: key);

  @override
  State<MenuRecommendationList> createState() => _MenuRecommendationListState();
}

class _MenuRecommendationListState extends State<MenuRecommendationList> {
  List<String> menus = [
    'Menu 1',
    'Menu 2',
    'Menu 3',
    'Menu 4',
    'Menu 5',
    'Menu 6',
  ];

  Future<List<Menu>?> getMenus(BuildContext context) async {
    try {
      // Initialize menu recommendation service
      final MenuRecommendationService menuRecommendation =
          MenuRecommendationService();

      final menus = await menuRecommendation.getMenuRecommendation();

      return menus;
    } catch (error) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Menu Recommendations",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Menu>?>(
            future: getMenus(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                    ));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No menus available',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ));
              } else {
                List<Menu> menus = snapshot.data!;

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  shrinkWrap: true,
                  primary: false,
                  itemCount: menus.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MenuDetailPage(menu: menus[index]),
                          ),
                        );
                      },
                      child: MenuCard(menu: menus[index]),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final Menu menu;

  const MenuCard({
    Key? key,
    required this.menu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      menu.thumbnailUrl,
                      fit: BoxFit.contain,
                    ))),
            const SizedBox(height: 16),
            Text(
              menu.name,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 8),
            Text(
              '${menu.calories} kcal',
              style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class MenuDetailPage extends StatelessWidget {
  final Menu menu;

  const MenuDetailPage({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Recipe', style: TextStyle(fontFamily: 'Poppins')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  menu.thumbnailUrl,
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                  child: Text(
                menu.name,
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              )),
              const SizedBox(height: 16),
              const Text(
                'Ingredients:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
              ...menu.ingredients.map((ingredient) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Icon(Icons.brightness_1, size: 10),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(
                        ingredient,
                        style: const TextStyle(fontFamily: 'Poppins'),
                      )),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              const Text(
                'Directions:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
              ...menu.directions.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final direction = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$index. ',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins')),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(
                        direction,
                        style: const TextStyle(fontFamily: 'Poppins'),
                      )),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
