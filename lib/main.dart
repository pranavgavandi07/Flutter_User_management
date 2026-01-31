import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_login/firebase_options.dart';

import 'navigation/app_pages.dart';
import 'navigation/app_routes.dart';

import 'controllers/auth_controller.dart';
import 'controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

   // Initialize controllers
   final authController = Get.put(AuthController());
   authController.loadUserFromPrefs();
   Get.put(UserController());

  runApp( MyApp());
}

class MyApp extends StatefulWidget {
   MyApp({super.key});



  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authController = Get.find<AuthController>(); 
  
  @override
  void initState() {
  
     // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:  authController.isLoggedIn ? AppRoutes.dashboard : AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}
