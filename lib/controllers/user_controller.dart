import 'package:get/get.dart';
import 'package:project_login/services/service.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  final UserService _service = UserService();

  final users = <UserModel>[].obs;
  final isLoading = false.obs;

  Future<void> addUser(String name, String email, String address) async {
    try {
      isLoading.value = true;

      await _service.addUser(
        UserModel(
          id: '',
          name: name.trim(),
          email: email.trim(),
          address: address.trim(),
        ),
      );

     Get.snackbar('Success', 'User added successfully');
    } catch (e) {
    Get.snackbar(
        'Error',
        'Failed to add user. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> updateUser(String docId, String name, String email, String address) async {
    try {
      isLoading.value = true;

      await _service.updateUserByDocId(docId, {
        'name': name.trim(),
        'email': email.trim(),
        'address': address.trim(),
      });
      Get.back();
      Get.snackbar('Success', 'User updated successfully');

    } catch (e) {
      Get.snackbar('Error', 'Failed to update user: $e');
    } finally {
      isLoading.value = false;
    }
  }




  Future<void> deleteUser(String id) async {
    try {
      isLoading.value = true;
      await _service.deleteUser(id);
      Get.snackbar('Success', 'User deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user');
    } finally {
      isLoading.value = false;
    }
  }
}
