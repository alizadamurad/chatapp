import 'package:chatapp/Models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    // GET USER INFO

    final String currentUserId = firebaseAuth.currentUser!.uid;
    final String currentUserEmail = firebaseAuth.currentUser!.email.toString();
    final Timestamp time = Timestamp.now();

    // CREATE NEW MESSAGE

    Message newMessage = Message(
      currentUserId,
      currentUserEmail,
      receiverId,
      message,
      time,
    );

    // CHAT ROOM

    List<String> ids = [currentUserId, receiverId];
    ids.sort();

    String chatRoomId = ids.join("_");

    // ADD NEW MESSAGE IN DATABASE
    await firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());

    // GET MESSAGE
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getLastMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('time', descending: true)
        .limit(1)
        .snapshots();
  }
}
