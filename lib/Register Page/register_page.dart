import 'package:chatapp/Locator/locator.dart';
import 'package:chatapp/Login%20Page/components/my_text_field.dart';
import 'package:chatapp/Login%20Page/components/sign_in_button.dart';
import 'package:chatapp/Service/AuthService/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? ontap;
  const RegisterPage({super.key, required this.ontap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController rePassController = TextEditingController();
  RxBool isLoading = RxBool(false);

  void register() async {
    isLoading.value = true;
    AuthService authService = locator<AuthService>();

    if (passController.text != rePassController.text) {
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
        messageText: const Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "Passwords do not match",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
            ),
          ),
        ),
      );
      return;
    }

    try {
      await authService.signUp(
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
                    "Let\'s create an account for you",
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
                    obsecureText: true,
                  ),

                  // Re enter Password TextField
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    controller: rePassController,
                    hintText: "Confirm password",
                    obsecureText: true,
                  ),
                  const SizedBox(
                    height: 35,
                  ),

                  //Sign in Button
                  Obx(() => isLoading.value
                      ? const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : MyButton(onTap: register, text: "Sign Up")),
                  const SizedBox(
                    height: 15,
                  ),
                  //Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already a member?",
                        style: TextStyle(fontFamily: "Poppins"),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: widget.ontap,
                        child: const Text(
                          "Sign in now",
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
