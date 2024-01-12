import 'package:flutter/material.dart';
import 'package:nutribuddies/services/database.dart';

class SeedingData {
  Future seedingData() async {
    String fotoTahu = await DatabaseService(uid: '').getPhotoUrl('tahu.jpg');
    await DatabaseService(uid: '').seedInitialFoodData(fotoTahu, fotoTahu);
  }
}
