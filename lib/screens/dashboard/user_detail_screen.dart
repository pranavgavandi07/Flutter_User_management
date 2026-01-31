import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_login/controllers/auth_controller.dart';
import 'package:project_login/controllers/user_controller.dart';
import '../../models/user_model.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  final userController = Get.find<UserController>();
  final authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = Get.arguments as UserModel;

    // Initialize controllers with current values
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    addressController = TextEditingController(text: user.address);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    readOnly: !authController.isAdmin.value,
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter name';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    readOnly: !authController.isAdmin.value,
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter email';
                      if (!GetUtils.isEmail(value)) return 'Enter valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    readOnly: !authController.isAdmin.value,
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter address';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  if(authController.isAdmin.value)...[
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          userController.updateUser(
                            user.id,
                            nameController.text.trim(),
                            emailController.text.trim(),
                            addressController.text.trim(),
                          );
                        },
                        child: const Text('Update User'),
                      ),
                    ),

                  ],
                if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Center(child: CircularProgressIndicator()),
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








// class UserDetailScreen extends StatelessWidget {
//   const UserDetailScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final UserModel user = Get.arguments;
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('User Detail')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Name: ${user.name}', style: const TextStyle(fontSize: 20)),
//             const SizedBox(height: 10),
//             Text('Email: ${user.email}', style: const TextStyle(fontSize: 20)),
//             const SizedBox(height: 10),
//             Text('Address: ${user.address}', style: const TextStyle(fontSize: 20)),
//           ],
//         ),
//       ),
//     );
//   }
// }
