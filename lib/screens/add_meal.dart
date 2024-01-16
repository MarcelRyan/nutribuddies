import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutribuddies/models/foods.dart';
import 'package:nutribuddies/models/tracker.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:nutribuddies/services/debouncer.dart';
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
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  String foodName = '';
  int amount = 0;
  Nutritions currentNutritions = Nutritions(
      calories: 0, proteins: 0, fiber: 0, fats: 0, carbs: 0, iron: 0);

  final now = DateTime.now();

  TextEditingController searchController = TextEditingController();
  List<Foods> filteredFoodRecords = [];

  @override
  Widget build(BuildContext context) {
    Future<List<Foods>> getListOfFoodsData(String searchQuery) async {
      List<Foods> foodsList = [];

      QuerySnapshot querySnapshot =
          await DatabaseService(uid: '').foodsCollection.get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        Foods food = Foods(
          foodName: data['foodName'] ?? '',
          nutritions: Nutritions.fromJson(data['nutritions'] ?? {}),
          portion: data['portion'] ?? '',
          thumbnailUrl: data['thumbnailUrl'],
        );

        // Check if the food name contains the search query
        if (food.foodName.toLowerCase().contains(searchQuery.toLowerCase())) {
          foodsList.add(food);
        }
      }

      return foodsList;
    }

    Future<void> loadData(String searchQuery) async {
      List<Foods> data = await getListOfFoodsData(searchQuery);
      setState(() {
        filteredFoodRecords = data;
      });
    }

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
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05, 0, 0, 0),
            margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.06,
                MediaQuery.of(context).size.height * 0.02,
                MediaQuery.of(context).size.width * 0.06,
                MediaQuery.of(context).size.height * 0.02),
            decoration: BoxDecoration(
              color: surfaceContainerHighest,
              borderRadius: BorderRadius.circular(65.0),
            ),
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.search),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.03,
                        0,
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.height * 0.004),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        _debouncer.run(() {
                          loadData(value);
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
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Foods>>(
              future: getListOfFoodsData(searchController.text),
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
                          width: MediaQuery.of(context).size.width * 0.77,
                          height: MediaQuery.of(context).size.height * 0.09,
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.035),
                          margin: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.035,
                              0,
                              MediaQuery.of(context).size.width * 0.035,
                              MediaQuery.of(context).size.height * 0.015),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.075,
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.02),
                                child: Image.network(
                                  record.thumbnailUrl ?? '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.55,
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height * 0.02,
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.017,
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.008),
                                      alignment: Alignment.centerLeft,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          record.foodName,
                                          style: const TextStyle(
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
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.014,
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.006),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "${record.nutritions.calories} kcal",
                                          style: const TextStyle(
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
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.008,
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      alignment: Alignment.centerLeft,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "Portion: ${record.portion}",
                                          style: const TextStyle(
                                            color: Color(0xFF74747E),
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            height: 0.13,
                                            letterSpacing: 0.50,
                                          ),
                                          textAlign: TextAlign.start,
                                          textDirection: TextDirection.ltr,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  _addMealModal(
                                      context, record, widget.tracker);
                                },
                                icon: const Icon(Icons.add_circle_rounded),
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
}

// ignore: camel_case_types
class addMealModal extends StatefulWidget {
  final Foods record;
  final Trackers? tracker;

  const addMealModal({super.key, required this.record, required this.tracker});

  @override
  // ignore: library_private_types_in_public_api
  _addMealModalState createState() => _addMealModalState();
}

// ignore: camel_case_types
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
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.325,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.015,
                  MediaQuery.of(context).size.height * 0.02,
                  MediaQuery.of(context).size.width * 0.015,
                  MediaQuery.of(context).size.height * 0.02),
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.03,
                            child: const Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Add Meal',
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    widget.record.foodName,
                                    style: const TextStyle(
                                      color: black,
                                      fontSize: 28,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 0.05,
                                    ),
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Image.network(
                          widget.record.thumbnailUrl ?? '',
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Portion: ${widget.record.portion}",
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          color: primary,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 0.13,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.12,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Calories",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: outline,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0.16,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02),
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "${widget.record.nutritions.calories} kcal",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: primary,
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
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Carbs",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: outline,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0.16,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02),
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "${widget.record.nutritions.carbs} gr",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: primary,
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
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.12,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Proteins",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: outline,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0.16,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02),
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "${widget.record.nutritions.proteins} gr",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: primary,
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
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.06,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Fats",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: outline,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0.16,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02),
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "${widget.record.nutritions.fats} gr",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: primary,
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.65,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: primary, width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_rounded),
                          color: primary,
                          onPressed: () {
                            _decrementCounter();
                          },
                        ),
                        const Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.32,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "$counter",
                              style: const TextStyle(
                                color: black,
                                fontSize: 22,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0.06,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add_circle_rounded),
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
            const Spacer(),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.045,
                    decoration: ShapeDecoration(
                      color: surfaceContainerLowest,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: outline),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      shadows: const [
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
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: primary,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 0.13,
                            letterSpacing: 0.50,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.22,
                    height: MediaQuery.of(context).size.height * 0.045,
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
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Save",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 0.13,
                            letterSpacing: 0.50,
                          ),
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
