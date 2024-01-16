import 'package:nutribuddies/models/foods.dart';

class Meals {
  final Foods food;
  int amount;

  Meals({required this.food, required this.amount});

  Map<String, dynamic> toJson() {
    return {
      'food': food.toJson(),
      'amount': amount,
    };
  }

  factory Meals.fromJson(Map<String, dynamic> json) {
    return Meals(
      food: Foods.fromJson(json['food'] ?? {}),
      amount: json['amount'] ?? 0,
    );
  }
}
