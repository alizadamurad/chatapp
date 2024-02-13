class CurrentUser {
  final String email;
  final String uid;

  CurrentUser({required this.email, required this.uid});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'uid': uid,
    };
  }

  CurrentUser.fromMap(Map<String, dynamic> userData)
      : email = userData["email"],
        uid = userData["uid"];
}
