import 'dart:math' as math; // import this

import 'package:chatapp/ChatBubble/chat_bubble_triangle.dart';
import 'package:flutter/material.dart';

class ReceivedMessage extends StatelessWidget {
  final String time;
  final String message;
  const ReceivedMessage({
    super.key,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = Flexible(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: CustomPaint(
            painter: Triangle(Colors.grey[300]!),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                      color: Colors.black, fontFamily: 'Poppins', fontSize: 14),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 8,
                    fontFamily: "Poppins",
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ));

    return Padding(
      padding: const EdgeInsets.only(right: 50.0, left: 18, top: 5, bottom: 5),
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
