import 'package:nutribuddies/models/nutritions.dart';
import 'package:nutribuddies/models/meals.dart';

class Trackers {
  final String uid;
  final String kidUid;
  final DateTime date;
  Nutritions currentNutritions;
  Nutritions maxNutritions;
  final List<Meals> meals;

  Trackers(
      {required this.uid,
      required this.kidUid,
      required this.date,
      required this.currentNutritions,
      required this.maxNutritions,
      required this.meals});
}
