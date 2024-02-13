import 'package:chatapp/Login%20Page/login_page.dart';
import 'package:chatapp/Register%20Page/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool isLoginPage = true;

  void changePage() {
    setState(() {
      isLoginPage = !isLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoginPage
        ? LoginPage(
            ontap: changePage,
          )
        : RegisterPage(
            ontap: changePage,
          );
  }
}
