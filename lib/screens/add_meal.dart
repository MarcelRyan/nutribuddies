import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutribuddies/models/foods.dart';
import 'package:nutribuddies/models/tracker.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:nutribuddies/services/debouncer.dart';
import '../constant/text_input_decoration.dart';
import 'package:nutribuddies/services/food_tracker.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:provider/provider.dart';
import '../constant/colors.dart';
import '../models/nutritions.dart';

class AddMeal extends StatefulWidget {
  final Trackers? tracker;
  const AddMeal({super.key, required this.tracker});

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  final FoodTrackerService _foodTracker = FoodTrackerService();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  String foodName = '';
  int amount = 0;
  Nutritions currentNutritions = Nutritions(
      calories: 0, proteins: 0, fiber: 0, fats: 0, carbs: 0, iron: 0);

  final now = DateTime.now();

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Users? users = Provider.of<Users?>(context);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Add Meal',
          style: TextStyle(
            color: black,
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        elevation: 0.0,
        backgroundColor: background,
        foregroundColor: black,
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
                        controller: searchController,
                        onChanged: (value) {
                          _debouncer.run(() {
                            setState(() {
                              searchController.text = value;
                            });
                          });
                        },
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
            child: FutureBuilder<List<Foods>>(
              future: DatabaseService(uid: users!.uid).getListOfFoodsData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Foods> foodRecords = snapshot.data!;
                  return ListView(
                    children: foodRecords.map(
                      (record) {
                        return Container(
                          width: 332,
                          height: 80,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.fromLTRB(25, 0, 25, 13),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Image.network(
                                  record.thumbnailUrl ?? '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: 184,
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 13,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(bottom: 6),
                                      child: Text(
                                        record.foodName,
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
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        "${record.nutritions.calories} kcal",
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
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  _addMealModal(
                                      context, record, widget.tracker);
                                },
                                icon: Icon(Icons.add_circle_rounded),
                                color: primary,
                                iconSize: 30.0,
                              )
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void _addMealModal(BuildContext context, Foods record, Trackers? tracker) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: addMealModal(record: record, tracker: tracker),
          );
        });
  }

  void _warningEditModal(BuildContext context, Foods record) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: WarningEditMealModal(record: record),
          );
        });
  }
}

class WarningDeleteMealModal extends StatelessWidget {
  final Foods record;

  WarningDeleteMealModal({required this.record});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: white,
      content: Container(
        width: 312,
        height: 160,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Warning",
                      style: TextStyle(
                        color: Color(0xFF1E1E1F),
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0.06,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 36,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            textAlign: TextAlign.start,
                            softWrap: true,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      'Are you sure want to delete your kid’s meal: ',
                                  style: TextStyle(
                                    color: Color(0xFF45484F),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0.10,
                                    letterSpacing: 0.25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                              textAlign: TextAlign.start,
                              softWrap: true,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: record.foodName,
                                    style: TextStyle(
                                      color: Color(0xFF45484F),
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      height: 0.10,
                                      letterSpacing: 0.25,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '?',
                                    style: TextStyle(
                                      color: Color(0xFF45484F),
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 0.10,
                                      letterSpacing: 0.25,
                                    ),
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 36,
            ),
            Row(
              children: [
                SizedBox(
                  width: 50,
                ),
                Container(
                  width: 130,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      // Ini kalau cancel delete
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none) // Set to transparent
                        ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xFF74747E),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.10,
                        letterSpacing: 0.10,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  width: 94,
                  height: 40,
                  decoration: ShapeDecoration(
                    color: Color(0xFFBB2E27),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Color(0x4C000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Delete algorithm
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFBB2E27),
                    ),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.10,
                        letterSpacing: 0.10,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WarningEditMealModal extends StatelessWidget {
  final Foods record;

  WarningEditMealModal({required this.record});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: white,
      content: Container(
        width: 265,
        height: 140,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Edit Meal",
                      style: TextStyle(
                        color: Color(0xFF1E1E1F),
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0.06,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 36,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Do you want to edit your kid's meal?",
                      style: TextStyle(
                        color: Color(0xFF45484F),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0.10,
                        letterSpacing: 0.25,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 36,
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Container(
                  width: 130,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Color(0x4C000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _editMealModal(context, record);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          primary), // Set the background color
                    ),
                    child: Text(
                      "Edit portion",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.10,
                        letterSpacing: 0.10,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  width: 94,
                  height: 40,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFBB2E27)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _warningDeleteModal(context, record);
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Color(0xFFBB2E27),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.10,
                        letterSpacing: 0.10,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _warningDeleteModal(BuildContext context, Foods record) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: WarningDeleteMealModal(record: record),
          );
        });
  }

  void _editMealModal(BuildContext context, Foods record) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: editMealModal(record: record),
          );
        });
  }
}

class editMealModal extends StatefulWidget {
  final Foods record;

  editMealModal({required this.record});

  @override
  _editMealModalState createState() => _editMealModalState();
}

class _editMealModalState extends State<editMealModal> {
  int counter = 1;

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (counter != 0) {
        counter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: white,
      content: Container(
        height: 268,
        width: 369,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                              'Edit Meal',
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
                                widget.record.foodName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0.05,
                                ),
                                overflow: TextOverflow.visible,
                              )),
                        ],
                      ),
                      Container(
                        width: 52,
                        height: 52,
                        child: Image.network(
                          widget.record.thumbnailUrl ?? '',
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 40,
                    width: 299,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(40),
                        color: Color(0xFAFAFA),
                        border: Border.all(color: primary, width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(30),
                            color: primary,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.remove_circle_rounded),
                            color: primary,
                            onPressed: () {
                              _decrementCounter();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 130,
                          child: Text(
                            "${counter}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0.06,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline_rounded),
                          color: primary,
                          onPressed: () {
                            _incrementCounter();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 86,
                  ),
                  Container(
                    width: 95,
                    height: 32,
                    decoration: ShapeDecoration(
                      color: Color(0xFFF9F9F9),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0xFF74747E)),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color(0xFF5674A7),
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 0.13,
                          letterSpacing: 0.50,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Container(
                    width: 75,
                    height: 32,
                    decoration: BoxDecoration(
                        color: black,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: ElevatedButton(
                      onPressed: () {
                        // Saving algorithm
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            primary), // Set the background color
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: white,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 0.13,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class addMealModal extends StatefulWidget {
  final Foods record;
  final Trackers? tracker;

  addMealModal({required this.record, required this.tracker});

  @override
  _addMealModalState createState() => _addMealModalState();
}

class _addMealModalState extends State<addMealModal> {
  final FoodTrackerService _foodTracker = FoodTrackerService();
  int counter = 1;

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (counter != 0) {
        counter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Users? users = Provider.of<Users?>(context);
    return AlertDialog(
      backgroundColor: white,
      content: Container(
        height: 268,
        width: 369,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                                widget.record.foodName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0.05,
                                ),
                                overflow: TextOverflow.visible,
                              )),
                        ],
                      ),
                      Container(
                        width: 52,
                        height: 52,
                        child: Image.network(
                          widget.record.thumbnailUrl ?? '',
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
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
                                "${widget.record.nutritions.calories} kcal",
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
                                "${widget.record.nutritions.carbs} gr",
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
                                "${widget.record.nutritions.proteins} gr",
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
                                "${widget.record.nutritions.fats} gr",
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 40,
                    width: 299,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(40),
                        color: Color(0xFAFAFA),
                        border: Border.all(color: primary, width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_rounded),
                          color: primary,
                          onPressed: () {
                            _decrementCounter();
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 120,
                          child: Text(
                            "${counter}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0.06,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_rounded),
                          color: primary,
                          onPressed: () {
                            _incrementCounter();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 66,
                  ),
                  Container(
                    width: 95,
                    height: 32,
                    decoration: ShapeDecoration(
                      color: Color(0xFFF9F9F9),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0xFF74747E)),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        backgroundColor: background,
                        foregroundColor: primary,
                        side: const BorderSide(color: outline, width: 1),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: primary,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 0.13,
                          letterSpacing: 0.50,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Container(
                    width: 75,
                    height: 32,
                    decoration: BoxDecoration(
                        color: black,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: ElevatedButton(
                      onPressed: () {
                        _foodTracker.saveMeal(
                            users!.uid, widget.tracker, widget.record, counter);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        backgroundColor: primary,
                        foregroundColor: onPrimary,
                      ),
                      child: Text(
                        "Save",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: white,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 0.13,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
