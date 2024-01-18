import 'package:cloud_firestore/cloud_firestore.dart';

class Forum {
  String forumId;
  String userId;
  String question;
  String profilePicture;
  String name;
  DateTime createdAt;
  List<ForumAnswers> answers;

  Forum({
    required this.forumId,
    required this.userId,
    required this.question,
    required this.profilePicture,
    required this.name,
    required this.createdAt,
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'question': question,
      'profilePicture': profilePicture,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }

  factory Forum.fromJson(Map<String, dynamic> data, String forumId) {
    return Forum(
      forumId: forumId,
      userId: data['userId'] ?? '',
      question: data['question'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      name: data['name'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      answers: (data['answers'] as List<dynamic>?)
              ?.map((answerData) => ForumAnswers.fromJson(answerData))
              .toList() ??
          [],
    );
  }
}

class ForumAnswers {
  String userId;
  String answer;
  String profilePicture;
  String name;
  DateTime createdAt;

  ForumAnswers({
    required this.userId,
    required this.answer,
    required this.profilePicture,
    required this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'answer': answer,
      'profilePicture': profilePicture,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ForumAnswers.fromJson(Map<String, dynamic> data) {
    return ForumAnswers(
      userId: data['userId'] ?? '',
      answer: data['answer'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      name: data['name'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
