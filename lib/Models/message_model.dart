import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp time;

  Message(
    this.senderId,
    this.senderEmail,
    this.receiverId,
    this.message,
    this.time,
  );

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'time': time,
    };
  }

  Message.fromMap(Map<String, dynamic> messageData)
      : message = messageData["message"],
        receiverId = messageData["receiverId"],
        senderEmail = messageData["senderEmail"],
        senderId = messageData["senderId"],
        time = messageData["time"];
}
