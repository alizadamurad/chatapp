import 'package:chatapp/ChatBubble/chat_bubble_recieve.dart';
import 'package:chatapp/ChatBubble/chat_bubble_send.dart';
import 'package:chatapp/Login%20Page/components/my_text_field.dart';
import 'package:chatapp/Models/friend_model.dart';
import 'package:chatapp/Models/message_model.dart';
import 'package:chatapp/Service/MessageService/message_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  final Friend friend;
  const ChatPage({super.key, required this.friend});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final MessageService messageService = MessageService();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  ScrollController scrollController = ScrollController();
  String userId = "";

  void scrollDown() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // scrollController.jumpTo(scrollController.position.maxScrollExtent);
      messageService.sendMessage(widget.friend.uid, _messageController.text);
      // scrollDown();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   scrollController.jumpTo(scrollController.position.maxScrollExtent);
    // });
    return Scaffold(
      backgroundColor: Color(0xff66b2b2),
      appBar: AppBar(
        backgroundColor: Color(0xff008080),
        // centerTitle: true,
        leadingWidth: 100,
        leading: Row(
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            Hero(
              tag: widget.friend.email,
              child: const CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 25,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ),
          ],
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.friend.email,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const Text(
              "beta version",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _buildMessageList(),
          ),
          // User Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Build Message Input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
                controller: _messageController,
                hintText: "Enter message",
                obsecureText: false),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
              size: 25,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  //Build Message Item
  Widget _buildMessageItem(DocumentSnapshot document) {
    bool isLastMessageIsMine = userId == firebaseAuth.currentUser!.uid;
    // print(document.data());
    Message message = Message.fromMap(document.data() as Map<String, dynamic>);
    userId = message.senderId;

    var alignment = message.senderId == firebaseAuth.currentUser!.uid
        ? Alignment.centerRight
        : Alignment.centerLeft;
    DateTime dateTime = message.time.toDate();
    String formattedTime =
        "${dateTime.hour}.${dateTime.minute.toString().padLeft(2, '0')}";
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: message.senderId == firebaseAuth.currentUser!.uid
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Text(message.senderEmail),
            message.senderId == firebaseAuth.currentUser!.uid
                ? SentMessage(
                    time: formattedTime,
                    message: message.message,
                    isSecondMessage: isLastMessageIsMine,
                  )
                : ReceivedMessage(
                    message: message.message,
                    time: formattedTime,
                  ),
          ],
        ),
      ),
    );
  }

  // Build Message List
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: messageService.getMessages(
          widget.friend.uid, firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
            "Error occured",
            style: TextStyle(fontFamily: "Poppins"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              height: 75,
              width: 75,
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        } else {
          // scrollController.jumpTo(0);
          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });
          return ListView(
            // reverse: true,
            controller: scrollController,
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        }
      },
    );
  }
}
