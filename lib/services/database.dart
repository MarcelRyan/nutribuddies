import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nutribuddies/models/article.dart';
import 'package:nutribuddies/models/meals.dart';
import 'package:nutribuddies/models/menu_recommendation.dart';
import 'package:nutribuddies/models/tracker.dart';
import 'package:nutribuddies/models/nutritions.dart';
import 'package:http/http.dart' as http;

import '../models/foods.dart';
import '../models/kids.dart';
import '../models/user.dart';

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

  final CollectionReference menuCollection =
      FirebaseFirestore.instance.collection('menu');

  final CollectionReference menuRecommendationCollection =
      FirebaseFirestore.instance.collection('menu_recommendation');

  final CollectionReference answersCollection =
      FirebaseFirestore.instance.collection('qna_menu_recommendation');

  final CollectionReference forumCollection =
      FirebaseFirestore.instance.collection('forum');

  final CollectionReference articleCollection =
      FirebaseFirestore.instance.collection('article');

  // users
  Future<bool> updateUserData({
    required String uid,
    required String displayName,
    required String email,
    required String profilePictureUrl,
    required List<String> topicInterest,
  }) async {
    assert(uid.isNotEmpty, 'UID must not be empty');
    assert(displayName.isNotEmpty, 'Display Name must not be empty');
    assert(email.isNotEmpty, 'Email must not be empty');

    Map<String, dynamic> data = {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'topicInterest': topicInterest,
    };

    try {
      await usersCollection.doc(uid).set(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  // get photo url
  Future<String> getPhotoUrl(String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      final photoUrl = await ref.getDownloadURL();
      return photoUrl;
    } catch (e) {
      return '';
    }
  }

  // get user data
  Future<Users> getUserData() async {
    QuerySnapshot querySnapshot =
        await usersCollection.where('uid', isEqualTo: uid).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      List<dynamic>? rawTopicsInterest = data['topicsInterest'];

      List<String> topicsInterest =
          (rawTopicsInterest != null && rawTopicsInterest.isNotEmpty)
              ? List<String>.from(rawTopicsInterest.cast<String>())
              : [];

      return Users(
        uid: data['uid'],
        email: data['email'],
        displayName: data['displayName'],
        profilePictureUrl: data['profilePictureUrl'],
        topicsInterest: topicsInterest,
      );
    } else {
      return Users(
        uid: '',
        email: '',
        displayName: '',
        profilePictureUrl: '',
        topicsInterest: [],
      );
    }
  }

  Future<String> uploadFile(PlatformFile? pickedFile) async {
    final path = '$uid/${pickedFile!.name}';
    final file = File(pickedFile.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      UploadTask uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});

      final photoUrl = await snapshot.ref.getDownloadURL();

      return photoUrl;
    } catch (e) {
      return '';
    }
  }

  // kids
  Future<bool> updateKidData({
    required String kidsUid,
    required String displayName,
    required DateTime dateOfBirth,
    required String gender,
    required double currentHeight,
    required double currentWeight,
    required double bornWeight,
    String? profilePictureUrl,
  }) async {
    assert(kidsUid.isNotEmpty, 'Kids UID must not be empty');
    assert(displayName.isNotEmpty, 'Display Name must not be empty');
    assert(gender.isNotEmpty, 'Gender must not be empty');
    assert(currentHeight >= 0, 'Current Height must not be negative');
    assert(currentWeight >= 0, 'Current Weight must not be negative');
    assert(bornWeight >= 0, 'Born Weight must not be negative');

    Map<String, dynamic> data = {
      'uid': kidsUid,
      'parentUid': uid,
      'displayName': displayName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'currentHeight': currentHeight,
      'currentWeight': currentWeight,
      'bornWeight': bornWeight,
    };

    if (profilePictureUrl != null) {
      data['profilePictureUrl'] = profilePictureUrl;
    }

    try {
      await kidsCollection.doc(kidsUid).set(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  // check if kidsUid unique
  Future<bool> isKidsUidUnique(String kidsUid) async {
    final docSnapshot = await kidsCollection.doc(kidsUid).get();
    return !docSnapshot.exists;
  }

  // get kids data
  Future<Kids> getKidData(String kidsUid) async {
    QuerySnapshot querySnapshot =
        await kidsCollection.where('uid', isEqualTo: kidsUid).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      return Kids(
        uid: data['uid'],
        parentUid: data['parentUid'],
        displayName: data['displayName'],
        dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
        gender: data['gender'],
        currentHeight: data['currentHeight'],
        currentWeight: data['currentWeight'],
        bornWeight: data['bornWeight'],
        profilePictureUrl: data['profilePictureUrl'],
      );
    } else {
      return Kids(
        uid: '',
        parentUid: '',
        displayName: '',
        dateOfBirth: DateTime.now(),
        gender: '',
        currentHeight: 0.0,
        currentWeight: 0.0,
        bornWeight: 0.0,
        profilePictureUrl: '',
      );
    }
  }

  // get list of kids
  Future<List<Kids>> getKidsList(String parentUid) async {
    QuerySnapshot querySnapshot =
        await kidsCollection.where('parentUid', isEqualTo: parentUid).get();

    List<Kids> kidsList = [];

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Kids kid = Kids(
        uid: data['uid'],
        parentUid: data['parentUid'],
        displayName: data['displayName'],
        dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
        gender: data['gender'],
        currentHeight: data['currentHeight'],
        currentWeight: data['currentWeight'],
        bornWeight: data['bornWeight'],
        profilePictureUrl: data['profilePictureUrl'],
      );

      kidsList.add(kid);
    }

    return kidsList;
  }

  Future<String> getKidUid(String parentUid, String kidDisplayName) async {
    QuerySnapshot querySnapshot = await trackersCollection
        .where('parentUid', isEqualTo: parentUid)
        .where('displayName', isEqualTo: kidDisplayName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;

      return data['uid'];
    } else {
      return '';
    }
  }

  Future<Kids> getfirstKid(String parentUid) async {
    QuerySnapshot querySnapshot = await kidsCollection
        .where('parentUid', isEqualTo: parentUid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;

      return Kids(
        uid: data['uid'],
        parentUid: data['parentUid'],
        displayName: data['displayName'],
        dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
        gender: data['gender'],
        currentHeight: data['currentHeight'],
        currentWeight: data['currentWeight'],
        bornWeight: data['bornWeight'],
        profilePictureUrl: data['profilePictureUrl'],
      );
    } else {
      return Kids(
        uid: '',
        parentUid: '',
        displayName: '',
        dateOfBirth: DateTime.now(),
        gender: '',
        currentHeight: 0.0,
        currentWeight: 0.0,
        bornWeight: 0.0,
        profilePictureUrl: '',
      );
    }
  }

  // foods
  Future<void> seedInitialFoodData(List<Foods> foods) async {
    // Seed data

    for (var foodData in foods) {
      QuerySnapshot querySnapshot = await foodsCollection
          .where('foodName', isEqualTo: foodData.foodName)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await foodsCollection.add(foodData.toJson());
      }
    }
  }

  // get foods
  Future<Foods> getFoodsData(String foodName) async {
    Nutritions defaultNutritions = Nutritions(
        calories: 0, proteins: 0, fiber: 0, fats: 0, carbs: 0, iron: 0);

    QuerySnapshot querySnapshot = await foodsCollection
        .where('foodName', isEqualTo: foodName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      return Foods(
          foodName: data['foodName'],
          portion: data['portion'],
          nutritions: Nutritions.fromJson(data['nutritions']),
          thumbnailUrl: data['thumbnailUrl']);
    } else {
      return Foods(
          foodName: '',
          portion: '',
          nutritions: defaultNutritions,
          thumbnailUrl: '');
    }
  }

  Future<List<Foods>> getListOfFoodsData() async {
    List<Foods> foodsList = [];

    QuerySnapshot querySnapshot = await foodsCollection.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      Foods food = Foods(
        foodName: data['foodName'] ?? '',
        nutritions: Nutritions.fromJson(data['nutritions'] ?? {}),
        portion: data['portion'] ?? '',
        thumbnailUrl: data['thumbnailUrl'],
      );
      foodsList.add(food);
    }

    return foodsList;
  }

  Future<List<Foods>> getListOfFoodsDatas(String searchQuery) async {
    List<Foods> foodsList = [];

    QuerySnapshot querySnapshot = await foodsCollection.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      Foods food = Foods(
        foodName: data['foodName'] ?? '',
        nutritions: Nutritions.fromJson(data['nutritions'] ?? {}),
        portion: data['portion'] ?? '',
        thumbnailUrl: data['thumbnailUrl'],
      );

      // Check if the food name contains the search query
      if (food.foodName.toLowerCase().contains(searchQuery.toLowerCase())) {
        foodsList.add(food);
      }
    }

    return foodsList;
  }

  // trackers
  Future<void> updateTrackerData({
    required String trackerUid,
    required String kidUid,
    required DateTime date,
    required Nutritions currentNutritions,
    // required Nutritions maxNutritions,
    required List<Meals> meals,
  }) async {
    assert(trackerUid.isNotEmpty, 'Tracker UID must not be empty');
    assert(kidUid.isNotEmpty, 'Kid UID must not be empty');

    Nutritions maxNutritions = await getMaxNutritions(kidUid);

    final querySnapshot = await trackersCollection
        .where('kidUid', isEqualTo: kidUid)
        .where('date', isEqualTo: DateTime(date.year, date.month, date.day))
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      Map<String, dynamic> data = {
        'uid': trackerUid,
        'kidUid': kidUid,
        'date': DateTime(date.year, date.month, date.day),
        'currentNutritions': currentNutritions.toJson(),
        'maxNutritions': maxNutritions.toJson(),
        'meals': meals.map((meal) => meal.toJson()).toList(),
      };

      await trackersCollection.doc(trackerUid).set(data);
    }
  }

  Future updateCurrentNutritionTrackerData(
      String trackerUid, Nutritions currentNutritions) async {
    return await trackersCollection.doc(trackerUid).update({
      'currentNutritions': currentNutritions.toJson(),
    });
  }

  Future addMealTrackerData(String trackerUid, Meals meals) async {
    QuerySnapshot querySnapshot = await trackersCollection
        .where('uid', isEqualTo: trackerUid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      List<dynamic> existingMeals = data['meals'] ?? [];

      existingMeals.add(meals.toJson());

      return await trackersCollection.doc(trackerUid).update({
        'meals': existingMeals,
      });
    } else {
      return null;
    }
  }

  Future<Trackers?> getCurrentTracker(String trackerUid) async {
    QuerySnapshot querySnapshot = await trackersCollection
        .where('uid', isEqualTo: trackerUid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;

      List<Map<String, dynamic>> mealsData =
          List<Map<String, dynamic>>.from(data['meals']);

      List<Meals> meals = mealsData.map((mealData) {
        return Meals.fromJson(mealData);
      }).toList();

      Trackers tracker = Trackers(
        uid: data['uid'],
        kidUid: data['kidUid'],
        date: (data['date'] as Timestamp).toDate(),
        currentNutritions: Nutritions.fromJson(data['currentNutritions']),
        maxNutritions: Nutritions.fromJson(data['maxNutritions']),
        meals: meals,
      );

      return tracker;
    } else {
      return null;
    }
  }

  Future<void> deleteMealFromTracker(String trackerUid, int mealIndex) async {
    try {
      final trackerDoc = await trackersCollection.doc(trackerUid).get();
      if (trackerDoc.exists) {
        final trackerData = trackerDoc.data() as Map<String, dynamic>;
        List<dynamic> mealsList = trackerData['meals'] ?? [];
        Nutritions currentNutritions =
            Nutritions.fromJson(trackerData['currentNutritions']);

        if (mealIndex >= 0 && mealIndex < mealsList.length) {
          Meals mealToRemove = Meals.fromJson(mealsList[mealIndex]);

          // subtract nutrition
          currentNutritions.calories -=
              mealToRemove.food.nutritions.calories * mealToRemove.amount;
          currentNutritions.proteins -=
              mealToRemove.food.nutritions.proteins * mealToRemove.amount;
          currentNutritions.fiber -=
              mealToRemove.food.nutritions.fiber * mealToRemove.amount;
          currentNutritions.fats -=
              mealToRemove.food.nutritions.fats * mealToRemove.amount;
          currentNutritions.carbs -=
              mealToRemove.food.nutritions.carbs * mealToRemove.amount;
          currentNutritions.iron -=
              mealToRemove.food.nutritions.iron * mealToRemove.amount;

          // remove meal
          mealsList.removeAt(mealIndex);

          // update tracker
          await trackersCollection.doc(trackerUid).update({
            'meals': mealsList,
            'currentNutritions': currentNutritions.toJson(),
          });
        }
      }
    } catch (e) {
      print('Error deleting meal: ${e.toString()}');
    }
  }

  Future<void> editMealInTracker(
      String trackerUid, int mealIndex, Foods food, int counter) async {
    try {
      final trackerDoc = await trackersCollection.doc(trackerUid).get();
      print('MASUKKKKKKKKKKKKK');
      if (trackerDoc.exists) {
        final trackerData = trackerDoc.data() as Map<String, dynamic>;
        List<dynamic> mealsList = trackerData['meals'] ?? [];
        Nutritions currentNutritions =
            Nutritions.fromJson(trackerData['currentNutritions']);

        if (mealIndex >= 0 && mealIndex < mealsList.length) {
          Meals originalMeal = Meals.fromJson(mealsList[mealIndex]);

          print(originalMeal.amount);
          // subtract nutrition
          currentNutritions.calories -=
              originalMeal.food.nutritions.calories * originalMeal.amount;
          currentNutritions.proteins -=
              originalMeal.food.nutritions.proteins * originalMeal.amount;
          currentNutritions.fiber -=
              originalMeal.food.nutritions.fiber * originalMeal.amount;
          currentNutritions.fats -=
              originalMeal.food.nutritions.fats * originalMeal.amount;
          currentNutritions.carbs -=
              originalMeal.food.nutritions.carbs * originalMeal.amount;
          currentNutritions.iron -=
              originalMeal.food.nutritions.iron * originalMeal.amount;

          print(counter);
          print(originalMeal.food);
          // Add nutrition
          currentNutritions.calories += food.nutritions.calories * counter;
          currentNutritions.proteins += food.nutritions.proteins * counter;
          currentNutritions.fiber += food.nutritions.fiber * counter;
          currentNutritions.fats += food.nutritions.fats * counter;
          currentNutritions.carbs += food.nutritions.carbs * counter;
          currentNutritions.iron += food.nutritions.iron * counter;

          Meals updatedMeal = Meals(food: food, amount: counter);

          // update meal
          mealsList[mealIndex] = updatedMeal.toJson();

          // Update the tracker document with the updated meals and currentNutritions
          await trackersCollection.doc(trackerUid).update({
            'meals': mealsList,
            'currentNutritions': currentNutritions.toJson(),
          });
        } else {
          print('Invalid meal index: $mealIndex');
        }
      } else {
        print('Tracker document not found for UID: $trackerUid');
      }
    } catch (e) {
      print('Error editing meal: $e');
    }
  }

  // check if kidsUid unique
  Future<bool> isTrackerUidUnique(String trackerUid) async {
    final docSnapshot = await trackersCollection.doc(trackerUid).get();
    return !docSnapshot.exists;
  }

  Future<String> getTrackerUid(String kidUid, DateTime date) async {
    QuerySnapshot querySnapshot = await trackersCollection
        .where('kidUid', isEqualTo: kidUid)
        .where('date', isEqualTo: date)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;

      return data['uid'];
    } else {
      return '';
    }
  }

  // Trackers? _getTrackerForToday(QuerySnapshot snapshot) {
  //   final now = DateTime.now();
  //   final today = DateTime(now.year, now.month, now.day);

  //   final matchingDoc = snapshot.docs.firstWhere(
  //     (doc) {
  //       Timestamp docTimestamp = doc.get('date');
  //       DateTime docDate = docTimestamp.toDate();
  //       DateTime todayDate = DateTime(today.year, today.month, today.day);

  //       return docDate == todayDate;
  //     },
  //   );

  //   // ignore: unnecessary_null_comparison
  //   if (matchingDoc != null) {
  //     Map<String, dynamic> data = matchingDoc.data() as Map<String, dynamic>;
  //     List<Meals> mealsList = [];
  //     if (data['meals'] != null) {
  //       for (var mealData in data['meals']) {
  //         Meals meal = Meals(
  //           food: mealData['food'],
  //           amount: mealData['amount'],
  //         );
  //         mealsList.add(meal);
  //       }
  //     }
  //     return Trackers(
  //         kidUid: data['kuidUid'] ?? '',
  //         uid: data['uid'] ?? '',
  //         date: data['date'].toDate() ?? '',
  //         currentNutritions: Nutritions(
  //           proteins: data['currentNutritions']['proteins'],
  //           fiber: data['currentNutritions']['fiber'],
  //           carbs: data['currentNutritions']['carbs'],
  //           calories: data['currentNutritions']['calories'],
  //           fats: data['currentNutritions']['fats'],
  //           iron: data['currentNutritions']['iron'],
  //         ),
  //         maxNutritions: Nutritions(
  //           proteins: data['maxNutritions']['proteins'],
  //           fiber: data['maxNutritions']['fiber'],
  //           carbs: data['maxNutritions']['carbs'],
  //           calories: data['maxNutritions']['calories'],
  //           fats: data['maxNutritions']['fats'],
  //           iron: data['maxNutritions']['iron'],
  //         ),
  //         meals: mealsList);
  //   } else {
  //     return null;
  //   }
  // }

  Trackers? _getTrackerForToday(QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;

      List<Map<String, dynamic>> mealsData =
          List<Map<String, dynamic>>.from(data['meals']);

      List<Meals> meals = mealsData.map((mealData) {
        return Meals.fromJson(mealData);
      }).toList();

      return Trackers(
        uid: data['uid'],
        kidUid: data['kidUid'],
        date: (data['date'] as Timestamp).toDate(),
        currentNutritions: Nutritions.fromJson(data['currentNutritions']),
        maxNutritions: Nutritions.fromJson(data['maxNutritions']),
        meals: meals,
      );
    } else {
      return null;
    }
  }

  Stream<Trackers?> tracker(String kidUid, DateTime date) {
    date = DateTime(date.year, date.month, date.day);
    return trackersCollection
        .where('kidUid', isEqualTo: kidUid)
        .where('date', isEqualTo: date)
        .snapshots()
        .map((querySnapshot) => _getTrackerForToday(querySnapshot));
  }

  Future<Nutritions> getMaxNutritions(String kidUid) async {
    try {
      QuerySnapshot querySnapshot =
          await kidsCollection.where('uid', isEqualTo: kidUid).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        int age = DateTime.now()
                .difference((data['dateOfBirth'] as Timestamp).toDate())
                .inDays ~/
            365;
        String gender = data['gender'];

        double calories = 0.0;
        double protein = 0.0;
        double fiber = 0.0;
        double fat = 0.0;
        double carbs = 0.0;
        double iron = 0.0;

        if (age >= 0 && age <= 3) {
          calories = 1000;
          protein = 13;
          fiber = 14.0;
          fat = 35;
          carbs = 130;
          iron = 7;
        } else if (age >= 4 && age <= 8) {
          if (gender.toLowerCase() == 'female') {
            calories = 1200;
            protein = 19;
            fiber = 16.8;
            fat = 30;
            carbs = 130;
            iron = 10;
          } else if (gender.toLowerCase() == 'male') {
            calories = 1500;
            protein = 19;
            fiber = 19.6;
            fat = 30;
            carbs = 130;
            iron = 10;
          }
        } else if (age >= 9 && age <= 13) {
          if (gender.toLowerCase() == 'female') {
            calories = 1600;
            protein = 34;
            fiber = 22.4;
            fat = 30;
            carbs = 130;
            iron = 8;
          } else if (gender.toLowerCase() == 'male') {
            calories = 1800;
            protein = 34;
            fiber = 25.2;
            fat = 30;
            carbs = 130;
            iron = 8;
          }
        } else if (age >= 14 && age <= 18) {
          if (gender.toLowerCase() == 'female') {
            calories = 1800;
            protein = 46;
            fiber = 25.2;
            fat = 30;
            carbs = 130;
            iron = 15;
          } else if (gender.toLowerCase() == 'male') {
            calories = 2700;
            protein = 52;
            fiber = 30.8;
            fat = 30;
            carbs = 130;
            iron = 11;
          }
        } else if (age >= 19 && age <= 30) {
          if (gender.toLowerCase() == 'female') {
            calories = 1800;
            protein = 46;
            fiber = 28.0;
            fat = 27.5;
            carbs = 130;
            iron = 18;
          } else if (gender.toLowerCase() == 'male') {
            calories = 2700;
            protein = 56;
            fiber = 33.6;
            fat = 27.5;
            carbs = 130;
            iron = 8;
          }
        } else if (age >= 31 && age <= 50) {
          if (gender.toLowerCase() == 'female') {
            calories = 1800;
            protein = 46;
            fiber = 25.2;
            fat = 27.5;
            carbs = 130;
            iron = 18;
          } else if (gender.toLowerCase() == 'male') {
            calories = 2200;
            protein = 56;
            fiber = 30.8;
            fat = 27.5;
            carbs = 130;
            iron = 8;
          }
        } else if (age >= 51) {
          if (gender.toLowerCase() == 'female') {
            calories = 1600;
            protein = 46;
            fiber = 22.4;
            fat = 27.5;
            carbs = 130;
            iron = 8;
          } else if (gender.toLowerCase() == 'male') {
            calories = 2000;
            protein = 56;
            fiber = 28.0;
            fat = 27.5;
            carbs = 130;
            iron = 8;
          }
        }

        return Nutritions(
          calories: calories,
          proteins: protein,
          fiber: fiber,
          fats: fat,
          carbs: carbs,
          iron: iron,
        );
      } else {
        return Nutritions(
          calories: 0,
          proteins: 0,
          fiber: 0,
          fats: 0,
          carbs: 0,
          iron: 0,
        );
      }
    } catch (e) {
      return Nutritions(
        calories: 0,
        proteins: 0,
        fiber: 0,
        fats: 0,
        carbs: 0,
        iron: 0,
      );
    }
  }

  // Get Answers
  Future<RecommendationAnswers> getRecommendationAnswers(
      String parentUid, String kidUid) async {
    QuerySnapshot querySnapshot = await answersCollection
        .where('parentUid', isEqualTo: parentUid)
        .where('kidUid', isEqualTo: kidUid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      return RecommendationAnswers(
          answers: data["answers"], kidUid: kidUid, parentUid: parentUid);
    } else {
      return RecommendationAnswers(
          answers: {"status": "failed"}, kidUid: kidUid, parentUid: parentUid);
    }
  }

  // Get Available Menu Recommendation
  Future<MenuRecommendation> getAvailMenuRecommendation(
      String parentUid, String kidUid) async {
    QuerySnapshot querySnapshot = await menuRecommendationCollection
        .where('parentUid', isEqualTo: parentUid)
        .where('kidUid', isEqualTo: kidUid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      return MenuRecommendation(
          recommendations:
              (data["recommendations"] as List<dynamic>).cast<String>(),
          kidUid: kidUid,
          parentUid: parentUid);
    } else {
      return MenuRecommendation(
          recommendations: ["failed"], kidUid: kidUid, parentUid: parentUid);
    }
  }

  // Add QnA Answers Menu Recommendation
  Future<void> saveQnARecommendation(
      Map<String, dynamic> answers, String kidUid, String parentUid) async {
    QuerySnapshot querySnapshot = await answersCollection
        .where('parentUid', isEqualTo: parentUid)
        .where('kidUid', isEqualTo: kidUid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      RecommendationAnswers newData = RecommendationAnswers(
          answers: answers, kidUid: kidUid, parentUid: parentUid);

      await answersCollection.add(newData.toJson());
    }
  }

  // Save Menu Recommendation
  Future<void> saveMenuRecommendation(
      List<String> recommendations, String kidUid, String parentUid) async {
    QuerySnapshot querySnapshot = await menuRecommendationCollection
        .where('parentUid', isEqualTo: parentUid)
        .where('kidUid', isEqualTo: kidUid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      MenuRecommendation newData = MenuRecommendation(
          recommendations: recommendations,
          kidUid: kidUid,
          parentUid: parentUid);

      await menuRecommendationCollection.add(newData.toJson());
    }
  }

  Future<List<Menu>> getMenuRecommendation(
      String parentUid, String kidUid) async {
    try {
      // Get RecommendationAnswers
      RecommendationAnswers recommendationAnswers =
          await getRecommendationAnswers(parentUid, kidUid);

      // Check if answers retrieval was successful
      if (recommendationAnswers.answers["status"] == "failed") {
        return [];
      }

      // Check if menu recommendation already exists
      MenuRecommendation menuRecommendation =
          await getAvailMenuRecommendation(parentUid, kidUid);

      if (menuRecommendation.recommendations.isNotEmpty &&
          menuRecommendation.recommendations[0] != "failed") {
        QuerySnapshot querySnapshot = await menuCollection
            .where(FieldPath.documentId,
                whereIn: menuRecommendation.recommendations)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs
              .map((doc) => Menu.fromJson(doc.data() as Map<String, dynamic>))
              .toList();
        }
        return [];
      } else {
        // Hit the API with obtained answers
        const String apiUrl =
            "https://nutribuddies-db33c.et.r.appspot.com/predict";
        final String requestBody = json.encode(recommendationAnswers.answers);

        try {
          // Dummy HTTP request (replace with actual implementation)
          final apiResponse = await http.post(Uri.parse(apiUrl),
              body: requestBody, headers: {'Content-Type': 'application/json'});

          if (apiResponse.statusCode == 200) {
            // Parse the API response to get the UID
            final Map<String, dynamic> apiResponseBody =
                json.decode(apiResponse.body);

            // Get menuCollection based on UID from API response
            List<String> recommendationsUIDs =
                (apiResponseBody["recommendations"] as List<dynamic>)
                    .map((e) => e.toString())
                    .toList();

            // Save menu recommendation
            await saveMenuRecommendation(
                recommendationsUIDs, kidUid, parentUid);

            // Get list of menus
            QuerySnapshot querySnapshot = await menuCollection
                .where(FieldPath.documentId, whereIn: recommendationsUIDs)
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              return querySnapshot.docs
                  .map((doc) =>
                      Menu.fromJson(doc.data() as Map<String, dynamic>))
                  .toList();
            }
          }
        } catch (e) {
          return [];
        }
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // article
  Future<Article> getArticleData() async {
    QuerySnapshot querySnapshot =
        await articleCollection.where('uid', isEqualTo: uid).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      List<dynamic>? rawTopics = data['topics'];

      List<String> topics = (rawTopics != null && rawTopics.isNotEmpty)
          ? List<String>.from(rawTopics.cast<String>())
          : [];

      return Article(
        uid: data['uid'],
        title: data['title'],
        date: data['date'],
        topics: topics,
        imageUrl: data['imageUrl'],
        content: data['content'],
      );
    } else {
      return Article(
        uid: '',
        title: '',
        date: DateTime.now(),
        topics: [],
        imageUrl: '',
        content: '',
      );
    }
  }

  Future<List<Article>> getListOfArticlesData() async {
    List<Article> articlesList = [];

    QuerySnapshot querySnapshot = await articleCollection.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      Article article = Article(
        uid: data['uid'] ?? '',
        title: data['title'],
        date: data['date'],
        topics: data['topics'] ?? [],
        imageUrl: data['imageUrl'],
        content: data['content'],
      );
      articlesList.add(article);
    }

    return articlesList;
  }

  Future<List<Article>> getListOfArticlesDatas(String searchQuery) async {
    List<Article> articlesList = [];

    QuerySnapshot querySnapshot = await articleCollection.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      Article article = Article(
        uid: data['uid'] ?? '',
        title: data['title'],
        date: data['date'],
        topics: data['topics'] ?? [],
        imageUrl: data['imageUrl'],
        content: data['content'],
      );

      // Check if the food name contains the search query
      if (article.title.toLowerCase().contains(searchQuery.toLowerCase())) {
        articlesList.add(article);
      }
    }

    return articlesList;
  }
}
