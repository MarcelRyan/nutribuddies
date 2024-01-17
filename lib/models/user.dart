class Users {
  final String uid;
  final String? displayName;
  final String? email;
  String? profilePictureUrl;
  List<String> topicsInterest;

  Users(
      {required this.uid,
      required this.displayName,
      required this.email,
      required this.profilePictureUrl,
      required this.topicsInterest});
}
