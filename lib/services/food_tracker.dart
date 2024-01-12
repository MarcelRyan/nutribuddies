import 'package:flutter/material.dart';
import 'package:nutribuddies/models/kids.dart';
import 'package:nutribuddies/models/nutritions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/screens/add_meal.dart';
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

  Future<void> saveMeal(String uid, String trackerUid,
      Nutritions currentNutritions, Nutritions addedNutritions) async {
    try {
      currentNutritions.proteins += addedNutritions.proteins;
      currentNutritions.fiber += addedNutritions.fiber;
      currentNutritions.carbs += addedNutritions.carbs;
      currentNutritions.calories += addedNutritions.calories;
      currentNutritions.fats += addedNutritions.fats;
      currentNutritions.sugar += addedNutritions.sugar;

      await DatabaseService(uid: uid)
          .updateCurrentNutritionTrackerData(trackerUid, currentNutritions);
    } catch (e) {
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
        calories: 0, proteins: 0, fiber: 0, fats: 0, carbs: 0, sugar: 0);

    Nutritions maxNutritions = Nutritions(
        calories: 100,
        proteins: 100,
        fiber: 100,
        fats: 100,
        carbs: 100,
        sugar: 100);
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
        trackerUid,
        kidUid,
        picked,
        currentNutritions,
        maxNutritions,
        meals,
      );
    }
  }
}
