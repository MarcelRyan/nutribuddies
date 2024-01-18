import 'package:nutribuddies/models/forum.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutribuddies/services/database.dart';

class ForumService {
  Future<List<Forum>?> getForum() async {
    List<Forum>? forums = await DatabaseService(uid: '').getForum();

    // Sort the forums based on the createdAt date in descending order
    forums.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return forums;
  }

  Future<Forum?> getForumById(String forumId) async {
    Forum? forums = await DatabaseService(uid: '').getForumById(forumId);

    return forums;
  }

  Future<void> createForum(String userId, String question,
      String profilePicture, String name) async {
    try {
      await DatabaseService(uid: '')
          .createForum(userId, question, profilePicture, name);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> answerForum(String forumId, String userId, String question,
      String profilePicture, String name) async {
    try {
      await DatabaseService(uid: '')
          .answerForum(forumId, userId, question, profilePicture, name);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
