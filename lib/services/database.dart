import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nutribuddies/models/meals.dart';
import 'package:nutribuddies/models/tracker.dart';
import 'package:nutribuddies/models/nutritions.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference kidsCollection =
      FirebaseFirestore.instance.collection('kids');

  final CollectionReference foodsCollection =
      FirebaseFirestore.instance.collection('foods');

  final CollectionReference trackersCollection =
      FirebaseFirestore.instance.collection('trackers');

  // users
  Future updateUserData(
      String displayName, String email, String? profilePictureUrl) async {
    return await usersCollection.doc(uid).set({
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
    });
  }

  Future<String> getPhotoUrl(String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      final photoUrl = await ref.getDownloadURL();
      return photoUrl;
    } catch (e) {
      return ''; // Return an empty string or null, depending on your requirements
    }
  }

  // kids
  Future updateKidData(
      String kidsUid,
      String displayName,
      DateTime dateOfBirth,
      String gender,
      double currentHeight,
      double currentWeight,
      double bornWeight,
      String? profilePictureUrl) async {
    return await kidsCollection.doc(uid).set({
      'uid': kidsUid,
      'parentUid': uid,
      'displayName': displayName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'currentHeight': currentHeight,
      'currentWeight': currentWeight,
      'bornWeight': bornWeight,
      'profilePictureUrl': profilePictureUrl,
    });
  }

  Future<bool> isKidsUidUnique(String kidsUid) async {
    final docSnapshot = await kidsCollection.doc(kidsUid).get();
    return !docSnapshot.exists;
  }

  // nutritions
  Future<void> seedInitialFoodData() async {
    Nutritions tahuNutritions = Nutritions(
        calories: 10, proteins: 10, fiber: 10, fats: 10, carbs: 10, sugar: 10);
    Nutritions tempeNutritions = Nutritions(
        calories: 20, proteins: 20, fiber: 20, fats: 20, carbs: 20, sugar: 20);

    List<Map<String, dynamic>> initialFoodData = [
      {'foodName': 'Tahu', 'nutritions': tahuNutritions.toJson()},
      {'foodName': 'Tempe', 'nutritions': tempeNutritions.toJson()},
    ];

    // Loop through the initial food data and add each item to the foodCollection
    for (var foodData in initialFoodData) {
      // Check if the foodName already exists in the collection
      QuerySnapshot querySnapshot = await foodsCollection
          .where('foodName', isEqualTo: foodData['foodName'])
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If the foodName doesn't exist, add it to the collection
        await foodsCollection.add(foodData);
      }
    }
  }

  Future updateCurrentNutritionTrackerData(Nutritions currentNutritions) async {
    return await trackersCollection.doc(uid).update({
      'currentNutritions': currentNutritions.toJson(),
    });
  }

  Future<Nutritions> getNutritionalInfo(String foodName) async {
    QuerySnapshot querySnapshot = await foodsCollection
        .where('foodName', isEqualTo: foodName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      return Nutritions(
        proteins: data['nutritions']['proteins'],
        fiber: data['nutritions']['fiber'],
        carbs: data['nutritions']['carbs'],
        calories: data['nutritions']['calories'],
        fats: data['nutritions']['fats'],
        sugar: data['nutritions']['sugar'],
      );
    } else {
      // Handle the case when the food information is not found
      return Nutritions(
          calories: 0, proteins: 0, fiber: 0, fats: 0, carbs: 0, sugar: 0);
    }
  }

  // trackers
  Future updateTrackerData(Nutritions currentNutritions,
      Nutritions maxNutritions, DateTime date) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final querySnapshot = await trackersCollection
        .where('uid', isEqualTo: uid)
        .where('date', isEqualTo: today)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return await trackersCollection.doc(uid).set({
        'uid': uid,
        'date': DateTime(date.year, date.month, date.day),
        'currentNutritions': currentNutritions.toJson(),
        'maxNutritions': maxNutritions.toJson(),
      });
    }
  }

  Future<Nutritions> getCurrentTrackerNutritions(
      String uid, DateTime date) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    QuerySnapshot querySnapshot = await trackersCollection
        .where('uid', isEqualTo: uid)
        .where('date', isEqualTo: today)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      return Nutritions(
        proteins: data['currentNutritions']['proteins'],
        fiber: data['currentNutritions']['fiber'],
        carbs: data['currentNutritions']['carbs'],
        calories: data['currentNutritions']['calories'],
        fats: data['currentNutritions']['fats'],
        sugar: data['currentNutritions']['sugar'],
      );
    } else {
      // Handle the case when the tracker information is not found
      return Nutritions(
          calories: 0, proteins: 0, fiber: 0, fats: 0, carbs: 0, sugar: 0);
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
      List<Meals> mealsList = [];
      if (data['meals'] != null) {
        for (var mealData in data['meals']) {
          Meals meal = Meals(
            food: mealData['food'],
            amount: mealData['amount'],
          );
          mealsList.add(meal);
        }
      }
      return Trackers(
          kidUid: '', // ntr ganti
          uid: data['uid'] ?? '',
          date: data['date'].toDate() ?? '',
          currentNutritions: Nutritions(
            proteins: data['currentNutritions']['proteins'],
            fiber: data['currentNutritions']['fiber'],
            carbs: data['currentNutritions']['carbs'],
            calories: data['currentNutritions']['calories'],
            fats: data['currentNutritions']['fats'],
            sugar: data['currentNutritions']['sugar'],
          ),
          maxNutritions: Nutritions(
            proteins: data['maxNutritions']['proteins'],
            fiber: data['maxNutritions']['fiber'],
            carbs: data['maxNutritions']['carbs'],
            calories: data['maxNutritions']['calories'],
            fats: data['maxNutritions']['fats'],
            sugar: data['maxNutritions']['sugar'],
          ),
          meals: mealsList);
    } else {
      return null;
    }
  }

  Stream<Trackers?> get tracker {
    return trackersCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_getTrackerForToday);
  }
}
