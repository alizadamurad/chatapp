class Friend {
  final String email;
  final String uid;

  Friend({
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'uid': uid,
    };
  }

  Friend.fromMap(Map<String, dynamic> userData)
      : email = userData["email"],
        uid = userData["uid"];
}
