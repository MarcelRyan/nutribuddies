import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nutribuddies/models/meals.dart';
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
      return Users(
        uid: data['uid'],
        email: data['email'],
        displayName: data['displayName'],
        profilePictureUrl: data['profilePictureUrl'],
      );
    } else {
      return Users(
        uid: '',
        email: '',
        displayName: '',
        profilePictureUrl: '',
      );
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
    return await kidsCollection.doc(kidsUid).set({
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

  // nutritions
  Future<void> seedInitialFoodData(String path, String path2) async {
    // Seed data
    Nutritions tahuNutritions = Nutritions(
        calories: 10, proteins: 10, fiber: 10, fats: 10, carbs: 10, sugar: 10);
    Nutritions tempeNutritions = Nutritions(
        calories: 20, proteins: 20, fiber: 20, fats: 20, carbs: 20, sugar: 20);

    List<Map<String, dynamic>> initialFoodData = [
      {
        'foodName': 'Tahu',
        'portion': '1 pc (30 gr)',
        'nutritions': tahuNutritions.toJson(),
        'thumbnail': path,
      },
      {
        'foodName': 'Tempe',
        'portion': '1 pc (30 gr)',
        'nutritions': tempeNutritions.toJson(),
        'thumbnail': path2,
      },
    ];

    // add each item to the foodCollection
    for (var foodData in initialFoodData) {
      // check if the foodName already exists
      QuerySnapshot querySnapshot = await foodsCollection
          .where('foodName', isEqualTo: foodData['foodName'])
          .get();

      if (querySnapshot.docs.isEmpty) {
        await foodsCollection.add(foodData);
      }
    }
  }

  // get foods
  Future<Foods> getFoodsData(String foodName) async {
    Nutritions defaultNutritions = Nutritions(
        calories: 0, proteins: 0, fiber: 0, fats: 0, carbs: 0, sugar: 0);

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

  // trackers
  Future updateTrackerData(
      String trackerUid,
      String kidUid,
      DateTime date,
      Nutritions currentNutritions,
      Nutritions maxNutritions,
      List<Meals> meals) async {
    final querySnapshot = await trackersCollection
        .where('kidUid', isEqualTo: kidUid)
        .where('date', isEqualTo: DateTime(date.year, date.month, date.day))
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return await trackersCollection.doc(trackerUid).set({
        'uid': trackerUid,
        'kidUid': kidUid,
        'date': DateTime(date.year, date.month, date.day),
        'currentNutritions': currentNutritions.toJson(),
        'maxNutritions': maxNutritions.toJson(),
        'meals': meals,
      });
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

      List<Meals> existingMeals = data['meals'] ?? [];

      existingMeals.add(meals.toJson() as Meals);

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
  //           sugar: data['currentNutritions']['sugar'],
  //         ),
  //         maxNutritions: Nutritions(
  //           proteins: data['maxNutritions']['proteins'],
  //           fiber: data['maxNutritions']['fiber'],
  //           carbs: data['maxNutritions']['carbs'],
  //           calories: data['maxNutritions']['calories'],
  //           fats: data['maxNutritions']['fats'],
  //           sugar: data['maxNutritions']['sugar'],
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
      // Handle the case when the tracker information is not found
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
}
