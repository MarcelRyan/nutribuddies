import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nutribuddies/models/foods.dart';
import 'package:nutribuddies/models/nutritions.dart';
import 'package:nutribuddies/services/database.dart';

class SeedingData {
  Future seedingData() async {
    String avocado = await DatabaseService(uid: '').getPhotoUrl('avocado.jpeg');
    String broccoli =
        await DatabaseService(uid: '').getPhotoUrl('broccoli.jpg');
    String cereal = await DatabaseService(uid: '').getPhotoUrl('cereal.jpeg');
    String chicken = await DatabaseService(uid: '').getPhotoUrl('chicken.jpeg');
    String chicken_nuggets =
        await DatabaseService(uid: '').getPhotoUrl('chicken_nuggets.jpg');
    String chicken_porridge =
        await DatabaseService(uid: '').getPhotoUrl('chicken_porridge.jpeg');
    String hamburger =
        await DatabaseService(uid: '').getPhotoUrl('hamburger.jpg');
    String mac_and_cheese =
        await DatabaseService(uid: '').getPhotoUrl('mac_and_cheese.jpeg');
    String milk = await DatabaseService(uid: '').getPhotoUrl('milk.jpeg');
    String peanut_butter =
        await DatabaseService(uid: '').getPhotoUrl('peanut_butter.jpg');
    String pizza = await DatabaseService(uid: '').getPhotoUrl('pizza.jpeg');
    String spaghetti =
        await DatabaseService(uid: '').getPhotoUrl('spaghetti.jpeg');
    String sweet_potato =
        await DatabaseService(uid: '').getPhotoUrl('sweet_potato.jpg');

    List<Foods> initialFoods = [
      Foods(
        foodName: 'Milk',
        portion: '1 cup (240 ml)',
        nutritions: Nutritions(
          calories: 149,
          proteins: 8,
          fiber: 0,
          fats: 8,
          carbs: 12,
          iron: 0,
        ),
        thumbnailUrl: milk,
      ),
      Foods(
        foodName: 'Milk',
        portion: '1 tablespoon (15 ml)',
        nutritions: Nutritions(
          calories: 7,
          proteins: 0.5,
          fiber: 0,
          fats: 0.2,
          carbs: 0.7,
          iron: 0,
        ),
        thumbnailUrl: milk,
      ),
      Foods(
        foodName: 'Peanut Butter',
        portion: '1 tablespoon (16 g)',
        nutritions: Nutritions(
          calories: 95,
          proteins: 8,
          fiber: 3,
          fats: 16,
          carbs: 7,
          iron: 0.7,
        ),
        thumbnailUrl: peanut_butter,
      ),
      Foods(
        foodName: 'Avocado',
        portion: '1 pcs (240 g)',
        nutritions: Nutritions(
          calories: 240,
          proteins: 3,
          fiber: 10,
          fats: 22,
          carbs: 13,
          iron: 1.1,
        ),
        thumbnailUrl: avocado,
      ),
      Foods(
        foodName: 'Broccoli',
        portion: '1 cup (90 g)',
        nutritions: Nutritions(
          calories: 35,
          proteins: 2.3,
          fiber: 2.2,
          fats: 0.3,
          carbs: 5.6,
          iron: 0.8,
        ),
        thumbnailUrl: broccoli,
      ),
      Foods(
        foodName: 'Chicken',
        portion: '1 large fillet (150 g)',
        nutritions: Nutritions(
          calories: 180,
          proteins: 33.8,
          fiber: 0,
          fats: 3.9,
          carbs: 0,
          iron: 2.3,
        ),
        thumbnailUrl: chicken,
      ),
      Foods(
        foodName: 'Chicken',
        portion: '1 medium fillet (120 g)',
        nutritions: Nutritions(
          calories: 144,
          proteins: 27,
          fiber: 0,
          fats: 3.1,
          carbs: 0,
          iron: 1.9,
        ),
        thumbnailUrl: chicken,
      ),
      Foods(
        foodName: 'Chicken',
        portion: '1 small fillet (80 g)',
        nutritions: Nutritions(
          calories: 96,
          proteins: 18,
          fiber: 0,
          fats: 2.1,
          carbs: 0,
          iron: 1.4,
        ),
        thumbnailUrl: chicken,
      ),
      Foods(
        foodName: 'Sweet Potato',
        portion: '1 pcs (180 g)',
        nutritions: Nutritions(
          calories: 112,
          proteins: 2,
          fiber: 3.9,
          fats: 0,
          carbs: 26,
          iron: 1.6,
        ),
        thumbnailUrl: sweet_potato,
      ),
      Foods(
        foodName: 'Mac and Cheese',
        portion: '1 cup (200 g)',
        nutritions: Nutritions(
          calories: 328,
          proteins: 7,
          fiber: 1.2,
          fats: 5,
          carbs: 23,
          iron: 2,
        ),
        thumbnailUrl: mac_and_cheese,
      ),
      Foods(
        foodName: 'Pizza',
        portion: '1 slice (107 g)',
        nutritions: Nutritions(
          calories: 282,
          proteins: 11,
          fiber: 2.3,
          fats: 10,
          carbs: 33,
          iron: 2.7,
        ),
        thumbnailUrl: pizza,
      ),
      Foods(
        foodName: 'Hamburger',
        portion: '1 patty (145 g)',
        nutritions: Nutritions(
          calories: 423,
          proteins: 25,
          fiber: 1.7,
          fats: 21,
          carbs: 36,
          iron: 5.9,
        ),
        thumbnailUrl: hamburger,
      ),
      Foods(
        foodName: 'Spaghetti',
        portion: '1 cup (140 g)',
        nutritions: Nutritions(
          calories: 221,
          proteins: 8.1,
          fiber: 2.5,
          fats: 1.3,
          carbs: 43.2,
          iron: 1.9,
        ),
        thumbnailUrl: spaghetti,
      ),
      Foods(
        foodName: 'Chicken nuggets',
        portion: '1 pcs (16 g)',
        nutritions: Nutritions(
          calories: 49,
          proteins: 2.5,
          fiber: 0.1,
          fats: 3.3,
          carbs: 2.4,
          iron: 0.1,
        ),
        thumbnailUrl: chicken_nuggets,
      ),
      Foods(
        foodName: 'Cereal',
        portion: '1 cup (28 g)',
        nutritions: Nutritions(
          calories: 105,
          proteins: 3.4,
          fiber: 2.6,
          fats: 1.9,
          carbs: 21,
          iron: 9.3,
        ),
        thumbnailUrl: cereal,
      ),
      Foods(
        foodName: 'Chicken porridge',
        portion: '1 bowl (120 g)',
        nutritions: Nutritions(
          calories: 300,
          proteins: 8,
          fiber: 0,
          fats: 5,
          carbs: 56,
          iron: 1,
        ),
        thumbnailUrl: chicken_porridge,
      ),
    ];
    await DatabaseService(uid: '').seedInitialFoodData(initialFoods);
  }
}
