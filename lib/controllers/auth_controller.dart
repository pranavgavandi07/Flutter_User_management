import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../navigation/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  static const String USER_LOGGED_IN_KEY = 'user_logged_in';

  var isLoading = false.obs;
  User? currentUser;
  RxBool isAdmin = false.obs;
  // bool get isAdmin => role.value == 'admin';
  // bool get isUser => role.value == 'user';
  //


  void signup(String email, String password, String role) async {
    try {
      isLoading.value = true;
      final user = await _authService.signup(email, password);
      if (user != null) {
        currentUser = user;
        await FirebaseFirestore.instance.collection('users_roles').doc(user.uid).set({
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
        });
        // await  fetchUserRole(email);
        await saveUserToPrefs();
        Get.offAllNamed(AppRoutes.dashboard);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Signup Error', e.message ?? 'Unknown error');
    } finally {
      isLoading.value = false;
    }
  }

  void login(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await _authService.login(email, password);
      if (user != null) {
        currentUser = user;
        // Fetch role from users_roles collection
      // await  fetchUserRole(email);
        await saveUserToPrefs();
        Get.offAllNamed(AppRoutes.dashboard);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Error', e.message ?? 'Unknown error');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> saveUserToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(USER_LOGGED_IN_KEY, true); // just a login flag
  }


  /// Load user session from SharedPreferences
  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(USER_LOGGED_IN_KEY) ?? false;

    // If user was logged in before, sync with FirebaseAuth
    if (loggedIn && _authService.currentUser != null) {
      currentUser = _authService.currentUser;
    }
  }


  Future<void> fetchUserRole(String email) async {
    final query = await FirebaseFirestore.instance
        .collection('users_roles')
        .where('email', isEqualTo: email)
        .get();

    if (query.docs.isNotEmpty) {
      final role = query.docs.first['role'];
      isAdmin.value = role == 'admin';
    } else {
      isAdmin.value = false;
    }
  }



  /// Logout method
  Future<void> logout() async {
    await _authService.logout();
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(USER_LOGGED_IN_KEY);
    Get.offAllNamed(AppRoutes.login);
  }


  /// Check if user is logged in
  bool get isLoggedIn => currentUser != null;
}
