class Article {
  String title;
  DateTime date;
  List<String> topics;
  String image;
  String content;

  Article(
      {required this.title,
        required this.date,
        required this.topics,
        required this.image,
        required this.content,
      });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'topics': topics,
      'image': image,
      'content': content,
    };
  }

  factory Article.fromJson(Map<String, dynamic> json){
    return Article(
        title: json['title'] ?? '',
        date: json['date'] ?? 0,
        topics: json['topics'] ?? [],
        image: json['image'] ?? '',
        content: json['content'] ?? '',
    );
  }
}