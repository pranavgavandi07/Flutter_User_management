import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  Future<void> addUser(UserModel user) async {
    await _db.collection('users').add(user.toJson());
  }

  Stream<List<UserModel>> getUsers() {
    return _db.collection('users').snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => UserModel.fromJson(doc.id, doc.data()))
          .toList(),
    );
  }

  /// Update user by Firestore doc ID
  Future<void> updateUserByDocId(String docId, Map<String, dynamic> data) async {
    await _db.collection("users").doc(docId).update(data);
  }

  Future<void> deleteUser(String id) async {
    await _db.collection('users').doc(id).delete();
  }
}
