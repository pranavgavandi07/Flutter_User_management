import 'package:get/get.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/dashboard/user_detail_screen.dart';
import '../screens/splash/auth_wrapper.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    // GetPage(name: AppRoutes.splash, page: () => const AuthWrapper()),
    GetPage(name: AppRoutes.login, page: () =>  LoginScreen()),
    GetPage(name: AppRoutes.signup, page: () =>  SignupScreen()),
    GetPage(name: AppRoutes.dashboard, page: () =>  DashboardScreen()),
    GetPage(name: AppRoutes.detail, page: () => const UserDetailScreen()),
  ];
}
