import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutribuddies/models/tracker.dart';
import '../constant/text_input_decoration.dart';
import 'package:nutribuddies/services/food_tracker.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:provider/provider.dart';
import '../constant/colors.dart';

class AddMeal extends StatefulWidget {
  const AddMeal({super.key});

  @override
  State<AddMeal> createState() => _AddMealState();
}

class DummyRecord {
  String name;
  double kcal;
  String portion;

  DummyRecord({required this.name, required this.kcal, required this.portion});
}

class _AddMealState extends State<AddMeal> {
  final FoodTrackerService _foodTracker = FoodTrackerService();
  String foodName = '';
  int amount = 0;
  Nutritions addedNutritions =
      Nutritions(protein: 0, fiber: 0, carbohydrate: 0);

  final now = DateTime.now();

  // fetchRecords() async {
  //   var records = await FirebaseFirestore.instance.collection()
  // }

  DummyRecord? selectedRecord;

  @override
  Widget build(BuildContext context) {
    final Users? users = Provider.of<Users?>(context);

    List<DummyRecord> dummyRecords = [
      DummyRecord(name: "Fried rice", kcal: 333, portion: "1 cup (140 gr)"),
      DummyRecord(
          name: "Chocolate cookies", kcal: 147, portion: "1 pcs (30 gr)"),
      DummyRecord(name: "Milk", kcal: 128, portion: "1 cup (250 ml)"),
      DummyRecord(name: "Boiled egg", kcal: 77, portion: "1 pcs (50 gr)"),
      DummyRecord(name: "Banana", kcal: 100, portion: "1 pcs (120 gr)"),
      DummyRecord(
          name: "Vanilla Ice Cream", kcal: 81, portion: "1 scoop (43 gr)"),
      DummyRecord(name: "Apple", kcal: 72, portion: "1 pcs (182 gr)")
    ];

    return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: const Text('Add Meal'),
          elevation: 0.0,
          backgroundColor: background,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                margin: EdgeInsets.fromLTRB(40.0, 14.0, 40.0, 20.0),
                decoration: BoxDecoration(
                  color: surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(65.0),
                ),
                height: 56,
                width: 332,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.search),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            15, 0, 0, 3), // Add horizontal padding
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Search meals...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: Column(
                  children: dummyRecords.map(
                (record) {
                  return Container(
                      width: 332,
                      height: 80,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.fromLTRB(40, 0, 40, 13),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Image.asset('assets/Login/Group1(1).png',
                                fit: BoxFit.cover),
                          ),
                          Container(
                              width: 184,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 13),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(bottom: 6),
                                      child: Text(
                                        record.name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 0.09,
                                          letterSpacing: 0.15,
                                        ),
                                        textAlign: TextAlign.start,
                                        textDirection: TextDirection.ltr,
                                      )),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      "${record.kcal} kcal",
                                      style: TextStyle(
                                        color: Color(0xFF5674A7),
                                        fontSize: 11,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 0.13,
                                        letterSpacing: 0.50,
                                      ),
                                      textAlign: TextAlign.start,
                                      textDirection: TextDirection.ltr,
                                    ),
                                  ),
                                  Text(
                                    "Portion: ${record.portion}",
                                    style: TextStyle(
                                      color: Color(0xFF74747E),
                                      fontSize: 11,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 0.13,
                                      letterSpacing: 0.50,
                                    ),
                                    textAlign: TextAlign.start,
                                    textDirection: TextDirection.ltr,
                                  )
                                ],
                              )),
                          Container(
                            height: 30,
                            width: 30,
                            child: IconButton(
                              onPressed: () {
                                _addMealModal(context, record);
                              },
                              icon: Icon(Icons.add),
                              color: white,
                              iconSize: 30.0,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primary,
                            ),
                          )
                        ],
                      ));
                },
              ).toList()),
            )
          ],
        ));
  }

  void _addMealModal(BuildContext context, DummyRecord record) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: addMealModal(record: record),
          );
        });
  }
}

class addMealModal extends StatefulWidget {
  final DummyRecord record;

  addMealModal({required this.record});

  @override
  _addMealModalState createState() => _addMealModalState();
}

class _addMealModalState extends State<addMealModal> {
  int counter = 1;

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 348,
        width: 369,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            height: 24,
                            child: Text(
                              'Add Meal',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0.09,
                                letterSpacing: 0.15,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                              width: 200,
                              child: Text(
                                widget.record.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0.05,
                                ),
                              )),
                        ],
                      ),
                      Container(
                        width: 52,
                        height: 52,
                        child: Image.asset('assets/Login/Group1(1).png',
                            fit: BoxFit.cover),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Portion: ${widget.record.portion}",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color(0xFF5674A7),
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.13,
                        letterSpacing: 0.50,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 25),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 65,
                              child: Text(
                                "Calories",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF74747E),
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0.16,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              width: 65,
                              child: Text(
                                "333 kcal",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF5674A7),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0.10,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 65,
                              child: Text(
                                "Carbs",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF74747E),
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0.16,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              width: 65,
                              child: Text(
                                "41.7 gr",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF5674A7),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0.10,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 65,
                              child: Text(
                                "Proteins",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF74747E),
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0.16,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              width: 65,
                              child: Text(
                                "12.47 gr",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF5674A7),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0.10,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 65,
                              child: Text(
                                "Fats",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF74747E),
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0.16,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              width: 65,
                              child: Text(
                                "12.34 gr",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF5674A7),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0.10,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 299,
                    padding: EdgeInsets.only(top: 100),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(40),
                        color: Color(0xFAFAFA),
                        border: Border.all(color: primary, width: 1)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
