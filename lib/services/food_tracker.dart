import 'package:nutribuddies/models/nutritions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/services/database.dart';

class FoodTrackerService {
  Future<Nutritions> getCurrentNutritionInfo(String uid, DateTime date) {
    return DatabaseService(uid: uid).getCurrentTrackerNutritions(uid, date);
  }

  Future<Nutritions> getNutritionalInfo(String foodName) {
    return DatabaseService(uid: '').getNutritionalInfo(foodName);
  }

  Future<void> addFood(String uid, Nutritions currentNutritions,
      Nutritions addedNutritions) async {
    try {
      currentNutritions.proteins += addedNutritions.proteins;
      currentNutritions.fiber += addedNutritions.fiber;
      currentNutritions.carbs += addedNutritions.carbs;

      await DatabaseService(uid: uid)
          .updateCurrentNutritionTrackerData(currentNutritions);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
