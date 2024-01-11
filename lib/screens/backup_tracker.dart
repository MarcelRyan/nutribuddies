import 'package:flutter/material.dart';
import 'package:nutribuddies/screens/add_food.dart';
import 'package:nutribuddies/models/tracker.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:provider/provider.dart';
import 'package:nutribuddies/models/nutritions.dart';

class Tracker extends StatelessWidget {
  const Tracker({super.key});

  @override
  Widget build(BuildContext context) {
    final Users? users = Provider.of<Users?>(context);

    return StreamProvider<Trackers?>.value(
      value: DatabaseService(uid: users!.uid).tracker,
      initialData: null,
      catchError: (context, error) {
        return null;
      },
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: const Text('Tracker'),
          backgroundColor: Colors.blue[400],
          elevation: 0.0,
        ),
        body: const TrackerContent(),
      ),
    );
  }
}

class TrackerContent extends StatefulWidget {
  const TrackerContent({super.key});

  @override
  State<TrackerContent> createState() => _TrackerContentState();
}

class _TrackerContentState extends State<TrackerContent> {
  @override
  Widget build(BuildContext context) {
    final tracker = Provider.of<Trackers?>(context);
    Nutritions currentNutritions = Nutritions(
        calories: 0, proteins: 0, fiber: 0, fats: 0, carbs: 0, sugar: 0);
    Nutritions maxNutritions = Nutritions(
        calories: 100,
        proteins: 100,
        fiber: 100,
        fats: 100,
        carbs: 100,
        sugar: 100);

    if (tracker != null) {
      currentNutritions = tracker.currentNutritions;
      maxNutritions = tracker.maxNutritions;
    }
    // print(tracker!.currentNutritions.protein);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Protein',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 100,
            lineHeight: 14.0,
            percent: (currentNutritions.proteins / maxNutritions.proteins)
                .clamp(0.0, 1.0),
            center: Text(
              '${((currentNutritions.proteins / maxNutritions.proteins) * 100).toStringAsFixed(1)} %',
              style: const TextStyle(fontSize: 12.0),
            ),
            animation: true,
            backgroundColor: Colors.grey,
            progressColor: Colors.blue,
          ),
          const SizedBox(height: 16),
          const Text(
            'Fiber',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 100,
            lineHeight: 14.0,
            percent:
                (currentNutritions.fiber / maxNutritions.fiber).clamp(0.0, 1.0),
            center: Text(
              '${((currentNutritions.fiber / maxNutritions.fiber) * 100).toStringAsFixed(1)} %',
              style: const TextStyle(fontSize: 12.0),
            ),
            animation: true,
            backgroundColor: Colors.grey,
            progressColor: Colors.blue,
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
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 100,
            lineHeight: 14.0,
            percent:
                (currentNutritions.carbs / maxNutritions.carbs).clamp(0.0, 1.0),
            center: Text(
              '${((currentNutritions.carbs / maxNutritions.carbs) * 100).toStringAsFixed(1)} %',
              style: const TextStyle(fontSize: 12.0),
            ),
            animation: true,
            backgroundColor: Colors.grey,
            progressColor: Colors.blue,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddFood()),
              );
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
    );
  }
}
