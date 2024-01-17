import 'package:nutribuddies/models/kids.dart';
import 'package:nutribuddies/models/menu_recommendation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/services/database.dart';

class MenuRecommendationService {
  Future<RecommendationAnswers?> getAnswers(
      String kidUid, String parentUid) async {
    return DatabaseService(uid: '').getRecommendationAnswers(parentUid, kidUid);
  }

  Future<void> saveAnswers(
      String kidUid, String parentUid, Map<String, dynamic> answers) async {
    try {
      await DatabaseService(uid: '')
          .saveQnARecommendation(answers, kidUid, parentUid);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<Kids?> getFirstKid(String parentUid) async {
    try {
      Kids kid = await DatabaseService(uid: parentUid).getfirstKid(parentUid);
      return kid;
    } catch (e) {
      return null;
    }
  }

  Future<List<Menu>?> getMenuRecommendation(
      String parentUid, String kidUid) async {
    try {
      List<Menu> menus = await DatabaseService(uid: '')
          .getMenuRecommendation(parentUid, kidUid);
      return menus;
    } catch (e) {
      return null;
    }
  }
}
