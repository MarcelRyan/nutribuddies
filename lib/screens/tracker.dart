import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/screens/add_meal.dart';
import 'package:nutribuddies/models/tracker.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:provider/provider.dart';
import 'package:nutribuddies/models/nutritions.dart';

import '../services/general.dart';

class Tracker extends StatelessWidget {
  const Tracker({super.key});

  @override
  Widget build(BuildContext context) {
    final Users? users = Provider.of<Users?>(context);

    return StreamProvider<Trackers?>.value(
      value: DatabaseService(uid: users!.uid).tracker,
      initialData: null,
      catchError: (context, error) {
        return null;
      },
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        body: const TrackerContent(),
      ),
    );
  }
}

class TrackerContent extends StatefulWidget {
  const TrackerContent({super.key});

  @override
  State<TrackerContent> createState() => _TrackerContentState();
}

class _TrackerContentState extends State<TrackerContent> {
  DateTime date = DateTime.now();
  final GeneralService general = GeneralService();

  @override
  Widget build(BuildContext context) {
    final GeneralService general = GeneralService();
    final tracker = Provider.of<Trackers?>(context);
    Nutritions currentNutritions = Nutritions(
        calories: 0, proteins: 0, fiber: 0, fats: 0, carbs: 0, sugar: 0);
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

    String selectedValue = 'Kid 1';

    return Scaffold(
      backgroundColor: background,
      body: Column(children: [
        Stack(
          children: [
            Image.asset('assets/Tracker/Rectangle_12308.png'),
            Positioned(
              top: 45,
              left: 145,
              height: 40,
              width: 100,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: primaryContainer,
                    contentPadding: EdgeInsets.fromLTRB(20, 0, 15, 0),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(width: 1, color: outline)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(width: 1, color: outline))),
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: <String>['Kid 1', 'Kid 2', 'Kid 3']
                    .map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                style: const TextStyle(
                  color: onPrimaryContainer,
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                elevation: 16,
                dropdownColor: primaryContainer,
                borderRadius: BorderRadius.circular(16),
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
                    general.selectDate(context, date, (picked) {
                      setState(() {
                        date = picked;
                      });
                    });
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
                                        child: const Center(
                                          child: Text(
                                            '15%',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
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
                                    child: const Row(
                                      children: [
                                        Text(
                                          '30 ',
                                          style: TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '/ 1000 kcal',
                                          style: TextStyle(
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
                                child: const Center(
                                  child: Text(
                                    '15%',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
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
                                    child: const Row(
                                      children: [
                                        Text(
                                          '30 ',
                                          style: TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '/ 1000 gr',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
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
                                child: const Center(
                                  child: Text(
                                    '15%',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
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
                                    child: const Row(
                                      children: [
                                        Text(
                                          '30 ',
                                          style: TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '/ 1000 gr',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
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
                                child: const Center(
                                  child: Text(
                                    '15%',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
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
                                    child: const Row(
                                      children: [
                                        Text(
                                          '30 ',
                                          style: TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '/ 1000 gr',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
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
                                child: const Center(
                                  child: Text(
                                    '15%',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
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
                                    child: const Row(
                                      children: [
                                        Text(
                                          '30 ',
                                          style: TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '/ 1000 gr',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
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
                                child: const Center(
                                  child: Text(
                                    '15%',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
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
                                    child: const Row(
                                      children: [
                                        Text(
                                          '30 ',
                                          style: TextStyle(
                                            color: ontertiaryContainer,
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '/ 1000 gr',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
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
                height: 10,
              ),
              Container(
                height: 100,
                width: 310,
                decoration: BoxDecoration(
                    color: tertiary99,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: const Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ]),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddMeal()));
                  },
                  child: const Text("Add Meal"),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
