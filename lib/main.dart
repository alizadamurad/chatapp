import 'package:chatapp/Locator/locator.dart';
import 'package:chatapp/Service/AuthService/auth_service.dart';
import 'package:chatapp/Login%20Page/login_page.dart';
import 'package:chatapp/OnBoardPage/on_board_page.dart';
import 'package:chatapp/Register%20Page/register_page.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/login_or_register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
        useMaterial3: true,
      ),
      home: const OnBoardPage(),
    );
  }
}
