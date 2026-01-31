// class UserModel {
//   String name;
//   String email;
//
//   UserModel({required this.name, required this.email});
// }
class UserModel {
  final String id;
  final String name;
  final String email;
  final String address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'address': address,
  };

  factory UserModel.fromJson(String id, Map<String, dynamic> json) {
    return UserModel(
      id: id,
      name: json['name'],
      email: json['email'],
      address: json['address'],
    );
  }
}
