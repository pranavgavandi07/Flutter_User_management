// class UserModel {
//   final String id;
//   final String name;
//   final String email;
//
//   UserModel({
//     required this.id,
//     required this.name,
//     required this.email,
//   });
//
//   Map<String, dynamic> toJson() => {
//     'name': name,
//     'email': email,
//   };
//
//   factory UserModel.fromJson(String id, Map<String, dynamic> json) {
//     return UserModel(
//       id: id,
//       name: json['name'],
//       email: json['email'],
//     );
//   }
// }
