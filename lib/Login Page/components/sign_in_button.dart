import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // hoverColor: Colors.white,
      highlightColor: Colors.white.withOpacity(0.2),
      splashColor: Colors.white.withOpacity(0.2),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(25),
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      onTap: onTap,
      child: Ink(
        height: 70,
        width: Get.width * 0.9,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              offset: Offset(5, 5),
              color: Colors.black,
            )
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          color: Colors.black,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
