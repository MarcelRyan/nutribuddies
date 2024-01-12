import 'package:nutribuddies/models/nutritions.dart';

class Foods {
  final String foodName;
  final String portion;
  final Nutritions nutritions;
  final String? thumbnailUrl;

  Foods(
      {required this.foodName,
      required this.nutritions,
      required this.portion,
      required this.thumbnailUrl});

  Map<String, dynamic> toJson() {
    return {
      'foodName': foodName,
      'nutritions': nutritions.toJson(),
      'portion': portion,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory Foods.fromJson(Map<String, dynamic> json) {
    return Foods(
      foodName: json['foodName'] ?? '',
      nutritions: Nutritions.fromJson(json['nutritions'] ?? {}),
      portion: json['portion'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}
