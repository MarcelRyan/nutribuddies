class Kids {
  final String uid;
  final String parentUid;
  final String? displayName;
  final DateTime dateOfBirth;
  final String gender;
  final double currentHeight;
  final double currentWeight;
  final double bornWeight;
  final String? profilePictureUrl;

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
