import 'package:ferreteria/models/user.dart';

class LoginResponse {
  bool logged;
  String token;
  bool isAdmin;
  User ? user;
  LoginResponse({required this.logged,required this.token, required this.isAdmin, this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      logged: json['logged'],
      token: json['token'],
      isAdmin: json['isAdmin'],
      user: User?.fromJson(json['user']),
    );
  }
}