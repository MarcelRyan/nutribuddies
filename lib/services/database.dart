import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nutribuddies/models/meals.dart';
import 'package:nutribuddies/models/menu_recommendation.dart';
import 'package:nutribuddies/models/tracker.dart';
import 'package:nutribuddies/models/nutritions.dart';

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

  final CollectionReference answersCollection =
      FirebaseFirestore.instance.collection('qna_menu_recommendation');

  final CollectionReference forumCollection =
      FirebaseFirestore.instance.collection('forum');

  // users
  Future<void> updateUserData({
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

    await usersCollection.doc(uid).set(data);
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

  // Get Menu Recommendation
  Future<List<Menu>> getMenuRecommendation() async {
    QuerySnapshot querySnapshot = await menuCollection.get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs
          .map((doc) => Menu.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }
}
