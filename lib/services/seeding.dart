import 'package:flutter/material.dart';
import 'package:nutribuddies/models/foods.dart';
import 'package:nutribuddies/models/nutritions.dart';
import 'package:nutribuddies/services/database.dart';

class SeedingData {
  Future seedingData() async {
    String fotoTahu = await DatabaseService(uid: '').getPhotoUrl('tahu.jpg');
    String fotoTempe = await DatabaseService(uid: '').getPhotoUrl('tempe.jpe');

    List<Foods> initialFoods = [
      Foods(
        foodName: 'Tahu',
        portion: '1 pc (30 gr)',
        nutritions: Nutritions(
          calories: 10,
          proteins: 10,
          fiber: 10,
          fats: 10,
          carbs: 10,
          iron: 10,
        ),
        thumbnailUrl: fotoTahu,
      ),
      Foods(
        foodName: 'Tempe',
        portion: '1 pc (30 gr)',
        nutritions: Nutritions(
          calories: 20,
          proteins: 20,
          fiber: 20,
          fats: 20,
          carbs: 20,
          iron: 20,
        ),
        thumbnailUrl: fotoTempe,
      ),
    ];
    await DatabaseService(uid: '').seedInitialFoodData(initialFoods);
  }
}
