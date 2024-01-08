import 'package:flutter/material.dart';
import 'package:nutribuddies/models/tracker.dart';
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
  String foodName = '';
  Nutritions addedNutritions =
      Nutritions(protein: 0, fiber: 0, carbohydrate: 0);

  // delete later
  Nutritions currentNutritions =
      Nutritions(protein: 0, fiber: 0, carbohydrate: 0);

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
              'Protein',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Protein'),
              validator: (val) => val!.isEmpty ? 'Enter the protein' : null,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (val) {
                setState(() => addedNutritions.protein = double.parse(val));
              },
            ),
            const Text(
              'Fiber',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Fiber'),
              validator: (val) => val!.isEmpty ? 'Enter the fiber' : null,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (val) {
                setState(() => addedNutritions.fiber = double.parse(val));
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Carbohydrate',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration:
                  textInputDecoration.copyWith(hintText: 'Carbohydrate'),
              validator: (val) =>
                  val!.isEmpty ? 'Enter the carbohydrate' : null,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (val) {
                setState(
                    () => addedNutritions.carbohydrate = double.parse(val));
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                addFood(users!.uid, currentNutritions, addedNutritions);
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
