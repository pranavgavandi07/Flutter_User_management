import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_login/screens/dashboard/dashboard_screen.dart';
import '../../controllers/auth_controller.dart';
import '../../navigation/app_routes.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return auth.isLoggedIn
        ? DashboardScreen() // Already logged in → dashboard will show
        : FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 500)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Get.offAllNamed(AppRoutes.login);
                });
              }
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          );
  }
}
