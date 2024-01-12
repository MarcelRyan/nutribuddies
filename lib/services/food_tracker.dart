import 'package:flutter/material.dart';
import 'package:nutribuddies/models/kids.dart';
import 'package:nutribuddies/models/nutritions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:uuid/uuid.dart';

import '../models/foods.dart';
import '../models/meals.dart';
import '../models/tracker.dart';

class FoodTrackerService {
  Future<Trackers?> getCurrentTracker(String kidUid, DateTime date) async {
    String trackerUid =
        await DatabaseService(uid: '').getTrackerUid(kidUid, date);
    return DatabaseService(uid: '').getCurrentTracker(trackerUid);
  }

  Future<Trackers?> getCurrentTrackerWithName(
      String uid, String kidDisplayName, DateTime date) async {
    String kidUid =
        await DatabaseService(uid: '').getKidUid(uid, kidDisplayName);
    return getCurrentTracker(kidUid, date);
  }

  Future<void> saveMeal(
      String uid, Trackers? tracker, Foods food, int amount) async {
    String trackerUid = tracker!.uid;
    Nutritions currentNutritions = tracker.currentNutritions;
    Nutritions addedNutritions = food.nutritions;
    try {
      currentNutritions.proteins += addedNutritions.proteins * amount;
      currentNutritions.fiber += addedNutritions.fiber * amount;
      currentNutritions.carbs += addedNutritions.carbs * amount;
      currentNutritions.calories += addedNutritions.calories * amount;
      currentNutritions.fats += addedNutritions.fats * amount;
      currentNutritions.iron += addedNutritions.iron * amount;

      Meals meal = Meals(food: food, amount: amount);

      await DatabaseService(uid: uid).addMealTrackerData(trackerUid, meal);

      await DatabaseService(uid: uid)
          .updateCurrentNutritionTrackerData(trackerUid, currentNutritions);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<Kids?> getFirstKid(String parentUid) async {
    try {
      Kids kid = await DatabaseService(uid: parentUid).getfirstKid(parentUid);
      return kid;
    } catch (e) {
      return null;
    }
  }

  Future<void> selectDateTracker(
    BuildContext context,
    DateTime selectedDate,
    Function(DateTime) onDateSelected,
    String parentUid,
    String kidUid,
  ) async {
    Nutritions currentNutritions = Nutritions(
        calories: 0, proteins: 0, fiber: 0, fats: 0, carbs: 0, iron: 0);

    Nutritions maxNutritions = Nutritions(
        calories: 100,
        proteins: 100,
        fiber: 100,
        fats: 100,
        carbs: 100,
        iron: 100);
    List<Meals> meals = [];

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);

      // generate tracker uid
      final String trackerUid = const Uuid().v4();

      // check if uid unique
      bool flagTracker =
          await DatabaseService(uid: parentUid).isTrackerUidUnique(trackerUid);
      while (!flagTracker) {
        flagTracker = await DatabaseService(uid: parentUid)
            .isTrackerUidUnique(trackerUid);
      }

      await DatabaseService(uid: '').updateTrackerData(
        trackerUid: trackerUid,
        kidUid: kidUid,
        date: picked,
        currentNutritions: currentNutritions,
        maxNutritions: maxNutritions,
        meals: meals,
      );
    }
  }
}
