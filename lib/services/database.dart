import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutribuddies/models/tracker.dart';
import 'package:nutribuddies/models/food.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference foodCollection =
      FirebaseFirestore.instance.collection('food');

  final CollectionReference trackerCollection =
      FirebaseFirestore.instance.collection('tracker');

  Future updateUserData(String name, String email) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
    });
  }

  Future updateTrackerData(Nutritions currentNutritions,
      Nutritions maxNutritions, DateTime date) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final querySnapshot = await trackerCollection
        .where('uid', isEqualTo: uid)
        .where('date', isEqualTo: today)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return await trackerCollection.doc(uid).set({
        'uid': uid,
        'date': DateTime(date.year, date.month, date.day),
        'currentNutritions': currentNutritions.toJson(),
        'maxNutritions': maxNutritions.toJson(),
      });
    }
  }

  Future<void> seedInitialFoodData() async {
    Nutritions tahuNutritions =
        Nutritions(protein: 1.0, fiber: 2.0, carbohydrate: 15.0);
    Nutritions tempeNutritions =
        Nutritions(protein: 1.0, fiber: 3.0, carbohydrate: 27.0);

    List<Map<String, dynamic>> initialFoodData = [
      {'foodName': 'Tahu', 'nutritions': tahuNutritions.toJson()},
      {'foodName': 'Tempe', 'nutritions': tempeNutritions},
    ];

    // Loop through the initial food data and add each item to the foodCollection
    for (var foodData in initialFoodData) {
      // Check if the foodName already exists in the collection
      QuerySnapshot querySnapshot = await foodCollection
          .where('foodName', isEqualTo: foodData['foodName'])
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If the foodName doesn't exist, add it to the collection
        await foodCollection.add(foodData);
      }
    }
  }

  Future updateCurrentNutritionTrackerData(Nutritions currentNutritions) async {
    return await trackerCollection.doc(uid).update({
      'currentNutritions': currentNutritions.toJson(),
    });
  }

  Future<Nutritions> getNutritionalInfo(String foodName) async {
    QuerySnapshot querySnapshot = await foodCollection
        .where('foodName', isEqualTo: foodName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      return Nutritions(
        protein: data['nutritions']['protein'],
        fiber: data['nutritions']['fiber'],
        carbohydrate: data['nutritions']['carbohydrate'],
      );
    } else {
      // Handle the case when the food information is not found
      return Nutritions(protein: 0, fiber: 0, carbohydrate: 0);
    }
  }

  Future<Nutritions> getCurrentTrackerNutritions(
      String uid, DateTime date) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    QuerySnapshot querySnapshot = await trackerCollection
        .where('uid', isEqualTo: uid)
        .where('date', isEqualTo: today)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      return Nutritions(
        protein: data['currentNutritions']['protein'],
        fiber: data['currentNutritions']['fiber'],
        carbohydrate: data['currentNutritions']['carbohydrate'],
      );
    } else {
      // Handle the case when the tracker information is not found
      return Nutritions(protein: 0, fiber: 0, carbohydrate: 0);
    }
  }

  Trackers? _getTrackerForToday(QuerySnapshot snapshot) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final matchingDoc = snapshot.docs.firstWhere(
      (doc) {
        Timestamp docTimestamp = doc.get('date');
        DateTime docDate = docTimestamp.toDate();
        DateTime todayDate = DateTime(today.year, today.month, today.day);

        return docDate == todayDate;
      },
    );

    // ignore: unnecessary_null_comparison
    if (matchingDoc != null) {
      Map<String, dynamic> data = matchingDoc.data() as Map<String, dynamic>;
      return Trackers(
        uid: data['uid'] ?? '',
        date: data['date'].toDate() ?? '',
        currentNutritions: Nutritions(
          protein: (data['currentNutritions']['protein'] as double),
          fiber: (data['currentNutritions']['fiber'] as double),
          carbohydrate: (data['currentNutritions']['carbohydrate'] as double),
        ),
        maxNutritions: Nutritions(
          protein: (data['maxNutritions']['protein'] as double),
          fiber: (data['maxNutritions']['fiber'] as double),
          carbohydrate: (data['maxNutritions']['carbohydrate'] as double),
        ),
      );
    } else {
      return null;
    }
  }

  Stream<Trackers?> get tracker {
    return trackerCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_getTrackerForToday);
  }
}
