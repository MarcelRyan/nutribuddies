import 'package:flutter/material.dart';
import 'package:nutribuddies/screens/add_food.dart';
import 'package:nutribuddies/models/tracker.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:provider/provider.dart';

class Tracker extends StatelessWidget {
  const Tracker({super.key});

  @override
  Widget build(BuildContext context) {
    final Users? users = Provider.of<Users?>(context);

    return StreamProvider<Trackers?>.value(
      value: DatabaseService(uid: users!.uid).tracker,
      initialData: null,
      catchError: (context, error) {
        print(error.toString());
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
    Nutritions currentNutritions =
        Nutritions(protein: 0, fiber: 0, carbohydrate: 0);
    Nutritions maxNutritions =
        Nutritions(protein: 100, fiber: 100, carbohydrate: 100);

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
            percent: currentNutritions.protein / maxNutritions.protein,
            center: Text(
              '${currentNutritions.protein / maxNutritions.protein * 100} %',
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
            percent: currentNutritions.fiber / maxNutritions.fiber,
            center: Text(
              '${currentNutritions.fiber / maxNutritions.fiber * 100} %',
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
                currentNutritions.carbohydrate / maxNutritions.carbohydrate,
            center: Text(
              '${currentNutritions.carbohydrate / maxNutritions.carbohydrate * 100} %',
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
