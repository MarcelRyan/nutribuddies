class Trackers {
  final String uid;
  final DateTime date;
  Nutritions currentNutritions;
  Nutritions maxNutritions;

  Trackers(
      {required this.uid,
      required this.date,
      required this.currentNutritions,
      required this.maxNutritions});
}

class Nutritions {
  double protein;
  double fiber;
  double carbohydrate;

  Nutritions(
      {required this.protein, required this.fiber, required this.carbohydrate});

  Map<String, dynamic> toJson() {
    return {
      'protein': protein,
      'fiber': fiber,
      'carbohydrate': carbohydrate,
    };
  }
}
