import 'package:chatapp/ChatBubble/chat_bubble_triangle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SentMessage extends StatelessWidget {
  final String message;
  final String time;
  final bool isSecondMessage;
  const SentMessage({
    super.key,
    required this.message,
    required this.isSecondMessage,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 14),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      time,
                      style: const TextStyle(
                        fontSize: 8,
                        fontFamily: "Poppins",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isSecondMessage
              ? Container()
              : CustomPaint(painter: Triangle(Colors.grey[900]!))
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 18.0, left: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const SizedBox(height: 30),
          messageTextGroup,
        ],
      ),
    );
  }
}
