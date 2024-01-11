class Nutritions {
  double calories;
  double fiber;
  double proteins;
  double fats;
  double sugar;
  double carbs;

  Nutritions(
      {required this.calories,
      required this.proteins,
      required this.fiber,
      required this.fats,
      required this.carbs,
      required this.sugar});

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'fats': fats,
      'sugar': sugar,
      'proteins': proteins,
      'fiber': fiber,
      'carbs': carbs,
    };
  }
}
