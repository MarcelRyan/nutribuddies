import 'package:nutribuddies/models/tracker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/services/database.dart';

void addFood(
    String uid, Nutritions currentNutritions, Nutritions addedNutritions) {
  try {
    currentNutritions.protein += addedNutritions.protein;
    currentNutritions.fiber += addedNutritions.fiber;
    currentNutritions.carbohydrate += addedNutritions.carbohydrate;
    // currentNutritions.protein += 10;
    // currentNutritions.fiber += 20;
    // currentNutritions.carbohydrate += 30;
    DatabaseService(uid: uid)
        .updateCurrentNutritionTrackerData(currentNutritions);
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
  }
}
