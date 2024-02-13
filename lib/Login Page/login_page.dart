import 'package:chatapp/Locator/locator.dart';
import 'package:chatapp/Service/AuthService/auth_service.dart';
import 'package:chatapp/Login%20Page/components/my_text_field.dart';
import 'package:chatapp/Login%20Page/components/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  final void Function()? ontap;
  const LoginPage({super.key, required this.ontap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  RxBool isLoading = RxBool(false);
  void signIn() async {
    isLoading.value = true;
    AuthService authService = locator<AuthService>();
    try {
      await authService.signInWithEmailAndPassword(
          emailController.text.trim(), passController.text.trim());
      isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "",
        "",
        borderWidth: 1,
        borderColor: Colors.black,
        barBlur: 20,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        titleText: Padding(
          padding: const EdgeInsets.all(2),
          child: Text(
            "Something went wrong",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: Colors.red[800]!,
              fontSize: 22,
            ),
          ),
        ),
        messageText: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            "${e.message}",
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400]!,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Logo

                  const Icon(
                    Icons.message_rounded,
                    size: 120,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //Welcome
                  Text(
                    "Welcome back you\'ve been missed",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Email TextField
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obsecureText: false,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //Password Textfield
                  MyTextField(
                      controller: passController,
                      hintText: "Password",
                      obsecureText: true),
                  const SizedBox(
                    height: 35,
                  ),

                  //Sign in Button
                  Obx(
                    () => isLoading.value
                        ? const SizedBox(
                            height: 55,
                            width: 55,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : MyButton(
                            onTap: () {
                              signIn();
                            },
                            text: "Sign In ",
                          ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Not a member?",
                        style: TextStyle(fontFamily: "Poppins"),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: widget.ontap,
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
