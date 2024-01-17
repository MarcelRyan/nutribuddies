class Menu {
  String name;
  String portion;
  String time;
  double carbs;
  double calories;
  double proteins;
  double fats;
  List<String> directions;
  List<String> ingredients;
  String thumbnailUrl;

  Menu(
      {required this.name,
      required this.portion,
      required this.time,
      required this.carbs,
      required this.calories,
      required this.proteins,
      required this.fats,
      required this.directions,
      required this.ingredients,
      required this.thumbnailUrl});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      name: json['name'] as String,
      portion: json['portion'] as String,
      time: json['time'] as String,
      carbs: json['carbs'] as double,
      calories: json['calories'] as double,
      proteins: json['proteins'] as double,
      fats: json['fats'] as double,
      directions: List<String>.from(json['directions']),
      ingredients: List<String>.from(json['ingredients']),
      thumbnailUrl: json["thumbnailUrl"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'portion': portion,
      'time': time,
      'carbs': carbs,
      'calories': calories,
      'proteins': proteins,
      'fats': fats,
      'directions': directions,
      'ingredients': ingredients,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}

class RecommendationAnswers {
  Map<String, dynamic> answers;
  String kidUid;
  String parentUid;

  RecommendationAnswers({
    required this.answers,
    required this.kidUid,
    required this.parentUid,
  });

  factory RecommendationAnswers.fromJson(Map<String, dynamic> json) {
    return RecommendationAnswers(
      answers: Map<String, dynamic>.from(json['answers']),
      kidUid: json['kidUid'] as String,
      parentUid: json['parentUid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answers': answers,
      'kidUid': kidUid,
      'parentUid': parentUid,
    };
  }
}
