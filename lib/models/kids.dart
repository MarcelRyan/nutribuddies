class Kids {
  final String uid;
  final String parentUid;
  String? displayName;
  DateTime dateOfBirth;
  String gender;
  double currentHeight;
  double currentWeight;
  double bornWeight;
  String? profilePictureUrl;

  Kids(
      {required this.uid,
      required this.parentUid,
      required this.displayName,
      required this.dateOfBirth,
      required this.gender,
      required this.currentHeight,
      required this.currentWeight,
      required this.bornWeight,
      required this.profilePictureUrl});
}
