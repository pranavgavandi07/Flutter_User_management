import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_login/services/service.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../navigation/app_routes.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final auth = Get.find<AuthController>();
  late final StreamSubscription _userSub;
  final authController = Get.find<AuthController>();
  final userController = Get.find<UserController>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserService _service = UserService();

  @override
  void initState() {
    super.initState();
    _userSub = _service.getUsers().listen(
          (data) {
        userController.users.assignAll(data);
      },
      onError: (e) {
        Get.snackbar('Error', 'Failed to load users');
      },
    );
    authController.fetchUserRole(authController.currentUser?.email ?? "");
  }

  @override
  void dispose() {
    _userSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body:  Obx((){
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Obx(() {
                  if (authController.isAdmin.value) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                if (!GetUtils.isEmail(value.trim())) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: addressController,
                              decoration: const InputDecoration(
                                labelText: 'Address',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Address is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    userController.addUser(
                                      nameController.text.trim(),
                                      emailController.text.trim(),
                                      addressController.text.trim(),
                                    );
                                    _formKey.currentState!.reset();
                                    nameController.clear();
                                    emailController.clear();
                                    addressController.clear();
                                  }
                                },
                                child: const Text('Add User'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),

                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'User List',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: userController.users.length,
                    itemBuilder: (context, index) {
                      final user = userController.users[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(user.name),
                          subtitle: Text(user.email),
                          trailing: Obx(() {
                            if (!authController.isAdmin.value) {
                              return const SizedBox.shrink();
                            }

                            return IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                Get.defaultDialog(
                                  title: 'Delete User',
                                  middleText: 'Are you sure you want to delete this user?',
                                  textCancel: 'Cancel',
                                  textConfirm: 'Delete',
                                  confirmTextColor: Colors.white,
                                  onConfirm: () {
                                    userController.deleteUser(user.id);
                                    Get.back();
                                  },
                                );
                              },
                            );
                          }),

                          onTap: () => Get.toNamed(AppRoutes.detail, arguments: user),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      })
    );
  }
}
