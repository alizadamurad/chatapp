import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // User Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // Create user Database
      await _firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(
        {
          "uid": userCredential.user!.uid,
          "email": email,
        },
        SetOptions(merge: true),
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  //User Register

  Future<UserCredential> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "uid": userCredential.user!.uid,
        "email": email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  //User Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
