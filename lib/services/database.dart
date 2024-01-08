import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutribuddies/models/tracker.dart';

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
    return await trackerCollection.doc(uid).set({
      'uid': uid,
      'date': DateTime(date.year, date.month, date.day),
      'currentNutritions': currentNutritions.toJson(),
      'maxNutritions': maxNutritions.toJson(),
    });
  }

  Future updateCurrentNutritionTrackerData(Nutritions currentNutritions) async {
    return await trackerCollection.doc(uid).update({
      'currentNutritions': currentNutritions.toJson(),
    });
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
