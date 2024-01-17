class ArticleTopicInterest {
  String topic;
  String topicImage;
  bool isInterested;

  ArticleTopicInterest(
  {required this.topic,
  required this.topicImage,
  required this.isInterested});

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'topicImage': topicImage,
      'isInterested': isInterested,
    };
  }

  factory ArticleTopicInterest.fromJson(Map<String, dynamic> json){
    return ArticleTopicInterest(
        topic: json['topic'] ?? '',
        topicImage: json['topicImage'] ?? '',
        isInterested: json['isInterested'] ?? 0
    );
  }
}