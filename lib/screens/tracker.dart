import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/models/kids.dart';
import 'package:nutribuddies/screens/add_meal.dart';
import 'package:nutribuddies/models/tracker.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:nutribuddies/services/food_tracker.dart';
import 'package:provider/provider.dart';
import 'package:nutribuddies/models/nutritions.dart';
import 'package:uuid/uuid.dart';

import '../models/meals.dart';
import '../services/general.dart';

class Tracker extends StatefulWidget {
  const Tracker({Key? key}) : super(key: key);

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  DateTime date = DateTime.now();
  late String kidUid;

  @override
  void initState() {
    super.initState();
    _initializeKidUid();
  }

  Future<void> _initializeKidUid() async {
    final Users? users = Provider.of<Users?>(context, listen: false);
    final FoodTrackerService foodTracker = FoodTrackerService();
    final firstKid = await foodTracker.getFirstKid(users!.uid);
    setState(() {
      kidUid = firstKid?.uid ?? '';
    });
    // generate tracker uid
    final String trackerUid = const Uuid().v4();

    // check if uid unique
    bool flagTracker =
        await DatabaseService(uid: users.uid).isTrackerUidUnique(trackerUid);
    while (!flagTracker) {
      flagTracker =
          await DatabaseService(uid: users.uid).isTrackerUidUnique(trackerUid);
    }

    DateTime today = DateTime.now();
    Nutritions currentNutritions = Nutritions(
        calories: 0, proteins: 0, fiber: 0, fats: 0, carbs: 0, sugar: 0);

    Nutritions maxNutritions = Nutritions(
        calories: 100,
        proteins: 100,
        fiber: 100,
        fats: 100,
        carbs: 100,
        sugar: 100);
    List<Meals> meals = [];

    await DatabaseService(uid: '').updateTrackerData(
      trackerUid,
      kidUid,
      DateTime(today.year, today.month, today.day),
      currentNutritions,
      maxNutritions,
      meals,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Users? users = Provider.of<Users?>(context);
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: StreamProvider<Trackers?>.value(
        value: DatabaseService(uid: users!.uid).tracker(kidUid, date),
        initialData: null,
        catchError: (context, error) {
          return null;
        },
        child: TrackerContent(
          updateDate: updateDate,
          updateKidUid: updateKidUid,
          kidUid: kidUid,
        ),
      ),
    );
  }

  void updateDate(DateTime newDate) {
    setState(() {
      date = newDate;
    });
  }

  void updateKidUid(String newKidUid) {
    setState(() {
      kidUid = newKidUid;
    });
  }
}

class TrackerContent extends StatefulWidget {
  final Function(String) updateKidUid;
  final Function(DateTime) updateDate;
  final String kidUid;
  const TrackerContent(
      {super.key,
      required this.updateKidUid,
      required this.updateDate,
      required this.kidUid});

  @override
  State<TrackerContent> createState() => _TrackerContentState();
}

class _TrackerContentState extends State<TrackerContent> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final GeneralService general = GeneralService();
    final FoodTrackerService foodTracker = FoodTrackerService();
    final tracker = Provider.of<Trackers?>(context);
    final users = Provider.of<Users?>(context);
    Nutritions currentNutritions = Nutritions(
        calories: 10, proteins: 0, fiber: 0, fats: 0, carbs: 0, sugar: 0);
    Nutritions maxNutritions = Nutritions(
        calories: 100,
        proteins: 100,
        fiber: 100,
        fats: 100,
        carbs: 100,
        sugar: 100);

    if (tracker != null) {
      currentNutritions = tracker.currentNutritions;
      maxNutritions = tracker.maxNutritions;
    }

    return Scaffold(
      backgroundColor: background,
      body: Column(children: [
        Stack(
          children: [
            Image.asset('assets/Tracker/Rectangle_12308.png'),
            Positioned(
              top: 45,
              left: 125,
              height: 40,
              width: 150,
              child: FutureBuilder<List<Kids>>(
                future: DatabaseService(uid: '').getKidsList(users!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No kids available');
                  } else {
                    List<Kids> kidsList = snapshot.data!;
                    Future<Kids?> firstKidFuture =
                        foodTracker.getFirstKid(users.uid);
                    String? selectedValue;

                    return FutureBuilder<Kids?>(
                        future: firstKidFuture,
                        builder: (context, kidSnapshot) {
                          if (kidSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (kidSnapshot.hasError) {
                            return Text('Error: ${kidSnapshot.error}');
                          } else {
                            Kids? firstKid = kidSnapshot.data;
                            selectedValue = firstKid?.uid;
                            return DropdownButtonFormField<String>(
                              value: selectedValue,
                              onChanged: (String? newValue) {
                                widget.updateKidUid(newValue ?? '');
                                setState(() {
                                  selectedValue = newValue;
                                });
                              },
                              items: kidsList.map<DropdownMenuItem<String>>(
                                (Kids kid) {
                                  return DropdownMenuItem<String>(
                                    value: kid.uid,
                                    child: Text(kid.displayName as String),
                                  );
                                },
                              ).toList(),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: primaryContainer,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 0, 15, 0),
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  borderSide:
                                      BorderSide(width: 1, color: outline),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  borderSide:
                                      BorderSide(width: 1, color: outline),
                                ),
                              ),
                              style: const TextStyle(
                                color: onPrimaryContainer,
                              ),
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.black),
                              elevation: 16,
                              dropdownColor: primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            );
                          }
                        });
                  }
                },
              ),
            ),
          ],
        ),
        Container(
          alignment: AlignmentDirectional.centerStart,
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    foodTracker.selectDateTracker(context, date, (picked) {
                      widget.updateDate(picked);
                      setState(() {
                        date = picked;
                      });
                    }, users.uid, widget.kidUid);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: primary,
                    foregroundColor: onPrimary,
                    side: const BorderSide(color: outline, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        general.formatDate(date),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Nutritions",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 250,
                width: 310,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 185,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFFAE4),
                                    Color(0xFFF9ECA5)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  offset: const Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ]),
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                          child: Stack(
                            children: [
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Image.asset(
                                      'assets/Tracker/Maskgroup(1).png')),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              secondary40, // Change color as needed
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${(currentNutritions.calories / maxNutritions.calories * 100).toStringAsFixed(0)}%',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: black,
                                              fontSize: 22,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Calories',
                                        style: TextStyle(
                                          color: ontertiaryContainer,
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 55),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Total',
                                      style: TextStyle(
                                        color: ontertiaryContainer,
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${(currentNutritions.calories).toStringAsFixed(0)} ',
                                          style: const TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '/ ${(maxNutritions.calories).toStringAsFixed(0)} kcal',
                                          style: const TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 55,
                          width: 150,
                          decoration: BoxDecoration(
                              color: tertiary70,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  offset: const Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ]),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: secondary40,
                                ),
                                child: Center(
                                  child: Text(
                                    '${(currentNutritions.fiber / maxNutritions.fiber * 100).toStringAsFixed(0)}%',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Fiber',
                                      style: TextStyle(
                                        color: ontertiaryContainer,
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${(currentNutritions.fiber).toStringAsFixed(0)} ',
                                          style: const TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '/ ${(maxNutritions.fiber).toStringAsFixed(0)} gr',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          height: 55,
                          width: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFAE4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                offset: const Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: secondary40,
                                ),
                                child: Center(
                                  child: Text(
                                    '${(currentNutritions.carbs / maxNutritions.carbs * 100).toStringAsFixed(0)}%',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Carbs',
                                      style: TextStyle(
                                        color: ontertiaryContainer,
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${(currentNutritions.carbs).toStringAsFixed(0)} ',
                                          style: const TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '/ ${(maxNutritions.carbs).toStringAsFixed(0)} gr',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 55,
                          width: 150,
                          decoration: BoxDecoration(
                              color: const Color(0xFFFCF3C7),
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
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: secondary40,
                                ),
                                child: Center(
                                  child: Text(
                                    '${(currentNutritions.proteins / maxNutritions.proteins * 100).toStringAsFixed(0)}%',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Proteins',
                                      style: TextStyle(
                                        color: ontertiaryContainer,
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${(currentNutritions.proteins).toStringAsFixed(0)} ',
                                          style: const TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '/ ${(maxNutritions.proteins).toStringAsFixed(0)}  gr',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 55,
                          width: 150,
                          decoration: BoxDecoration(
                              color: tertiary80,
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
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: secondary40,
                                ),
                                child: Center(
                                  child: Text(
                                    '${(currentNutritions.fats / maxNutritions.fats * 100).toStringAsFixed(0)}%',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Fats',
                                      style: TextStyle(
                                        color: ontertiaryContainer,
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${(currentNutritions.fats).toStringAsFixed(0)} ',
                                          style: const TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '/ ${(maxNutritions.fats).toStringAsFixed(0)} gr',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 55,
                          width: 150,
                          decoration: BoxDecoration(
                              color: tertiary70,
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
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: secondary40,
                                ),
                                child: Center(
                                  child: Text(
                                    '${(currentNutritions.sugar / maxNutritions.sugar * 100).toStringAsFixed(0)}%',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Sugar',
                                      style: TextStyle(
                                        color: ontertiaryContainer,
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${(currentNutritions.sugar).toStringAsFixed(0)} ',
                                          style: const TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '/ ${(maxNutritions.sugar).toStringAsFixed(0)} gr',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Kid's Meals",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15),
              ),
              // Container(
              //   height: 100,
              //   width: 310,
              //   decoration: BoxDecoration(
              //       color: tertiary99,
              //       borderRadius: const BorderRadius.all(Radius.circular(10)),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.grey.withOpacity(0.4),
              //           offset: const Offset(2, 4),
              //           blurRadius: 5,
              //           spreadRadius: 1,
              //         ),
              //       ]),
              // ),
            ],
          ),
        ),
      ]),
    );
  }
}
