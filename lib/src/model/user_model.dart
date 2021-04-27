import 'dart:convert';

class UserModel {
  int id;
  String name;
  String email;
  String password;
  String role;

  UserModel({this.id, this.name, this.email, this.password, this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      password: json['password']);

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "name": this.name,
        "email": this.email,
        "role": this.role,
        "password": this.password
      };

  static UserModel toUserModel(String str) {
    final jsonData = json.decode(str);
    return UserModel.fromJson(jsonData);
  }

  static String toJsonEncode(UserModel user) {
    final json = user.toJson();
    return jsonEncode(json);
  }
}
