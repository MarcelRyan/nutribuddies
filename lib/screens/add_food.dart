import 'package:flutter/material.dart';
import 'package:nutribuddies/models/nutritions.dart';
import '../constant/text_input_decoration.dart';
import 'package:nutribuddies/services/food_tracker.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:provider/provider.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final FoodTrackerService _foodTracker = FoodTrackerService();
  String foodName = '';
  int amount = 0;
  Nutritions addedNutritions = Nutritions(
      calories: 0, proteins: 0, fiber: 0, fats: 0, carbs: 0, sugar: 0);

  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final Users? users = Provider.of<Users?>(context);

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Add Food'),
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Food Name',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Food Name'),
              validator: (val) => val!.isEmpty ? 'Enter the food name' : null,
              onChanged: (val) {
                setState(() => foodName = val);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Amount',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Amount'),
              validator: (val) => val!.isEmpty ? 'Enter the amount' : null,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (val) {
                setState(() => amount = int.parse(val));
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // Fetch nutritional information from tracker
                final today = DateTime(now.year, now.month, now.day);
                Nutritions currentNutritions = await _foodTracker
                    .getCurrentNutritionInfo(users!.uid, today);

                // Fetch nutritional information based on the entered food name
                Nutritions foodNutritions =
                    await _foodTracker.getNutritionalInfo(foodName);

                // Calculate the total nutritional values based on the specified amount
                addedNutritions = Nutritions(
                    proteins: foodNutritions.proteins * amount,
                    fiber: foodNutritions.fiber * amount,
                    carbs: foodNutritions.carbs * amount,
                    fats: 0,
                    sugar: 0,
                    calories: 0);

                // add added nutritions
                await _foodTracker.addMeal(
                    users.uid, currentNutritions, addedNutritions);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Add Food'),
            ),
          ],
        ),
      ),
    );
  }
}
