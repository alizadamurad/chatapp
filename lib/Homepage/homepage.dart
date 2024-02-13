import 'package:chatapp/ChatPage/chat_page.dart';
import 'package:chatapp/Locator/locator.dart';
import 'package:chatapp/Models/friend_model.dart';
import 'package:chatapp/Models/message_model.dart';
import 'package:chatapp/Service/AuthService/auth_service.dart';
import 'package:chatapp/Service/MessageService/message_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  MessageService messageService = MessageService();
  String time = "";
  @override
  Widget build(BuildContext context) {
    AuthService authService = locator<AuthService>();
    return Scaffold(
      backgroundColor: Color(0xff66b2b2),
      appBar: AppBar(
        backgroundColor: Color(0xff008080),
        centerTitle: true,
        title: const Text(
          "Chat App",
          style: TextStyle(
            fontFamily: "Poppins",
            color: Colors.white,
            // fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              authService.signOut();
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildLastMessage(userId, otherUserId) {
    return StreamBuilder(
      stream: messageService.getLastMessage(userId, otherUserId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("ERROR");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          QueryDocumentSnapshot? lastMessageSnapshot =
              snapshot.data?.docs.first;

          Map<String, dynamic> messageData =
              lastMessageSnapshot?.data() as Map<String, dynamic>;

          Message lastMessage = Message.fromMap(messageData);
          DateTime dateTime = lastMessage.time.toDate();
          String formattedTime =
              "${dateTime.hour}.${dateTime.minute.toString().padLeft(2, '0')}";
          time = formattedTime;

          print("ALL DATA ${lastMessage.message}");

          return Row(
            children: [
              lastMessage.senderId == _auth.currentUser!.uid
                  ? const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.done,
                        size: 18,
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                width: Get.width * 0.5,
                child: Text(
                  lastMessage.message,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        } else {
          return const Text("");
        }
      },
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 55,
            width: 55,
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }
        if (snapshot.hasError) {
          const Text(
            "Error occured",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 60,
            ),
          );
        }
        return ListView(
          physics: const BouncingScrollPhysics(),
          children: snapshot.data!.docs
              .map<Widget>(
                (doc) => _buildUserListItem(doc),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Friend friend = Friend.fromMap(document.data() as Map<String, dynamic>);
    if (_auth.currentUser!.email != friend.email) {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          highlightColor: Colors.white.withOpacity(0.2),
          onTap: () {
            Get.to(() => ChatPage(
                  friend: friend,
                ));
          },
          child: Ink(
            child: Card(
              surfaceTintColor: Colors.green,
              shape: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(
                  width: 0.5,
                ),
              ),
              elevation: 8,
              color: Colors.grey[350],
              child: ListTile(
                trailing: Text(
                  time,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                  ),
                ),
                leading: Hero(
                  tag: friend.email,
                  child: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 35,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(friend.email),
                ),
                subtitle: _buildLastMessage(friend.uid, _auth.currentUser!.uid),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
