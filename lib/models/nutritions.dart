class Nutritions {
  double calories;
  double fiber;
  double proteins;
  double fats;
  double iron;
  double carbs;

  Nutritions(
      {required this.calories,
      required this.proteins,
      required this.fiber,
      required this.fats,
      required this.carbs,
      required this.iron});

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'fats': fats,
      'iron': iron,
      'proteins': proteins,
      'fiber': fiber,
      'carbs': carbs,
    };
  }

  factory Nutritions.fromJson(Map<String, dynamic> json) {
    return Nutritions(
      calories: json['calories'] ?? 0.0,
      proteins: json['proteins'] ?? 0.0,
      fiber: json['fiber'] ?? 0.0,
      fats: json['fats'] ?? 0.0,
      carbs: json['carbs'] ?? 0.0,
      iron: json['iron'] ?? 0.0,
    );
  }
}
