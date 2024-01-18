import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String uid;
  String title;
  Timestamp date;
  List<String> topics;
  String imageUrl;
  String content;

  Article(
      {required this.uid,
        required this.title,
        required this.date,
        required this.topics,
        required this.imageUrl,
        required this.content,
      });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'date': date,
      'topics': topics,
      'imageUrl': imageUrl,
      'content': content,
    };
  }

  factory Article.fromJson(Map<String, dynamic> json){
    return Article(
        uid: json['uid'] ?? '',
        title: json['title'] ?? '',
        date: json['date'] ?? 0,
        topics: json['topics'] ?? [],
        imageUrl: json['imageUrl'] ?? '',
        content: json['content'] ?? '',
    );
  }
}