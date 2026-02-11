import 'dart:convert';

class LoginOutputModel {
  String accessToken;
  String refreshToken;

  LoginOutputModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginOutputModel.fromMap(Map<String, dynamic> map) {
    return LoginOutputModel(
      accessToken: map['access_token'] ?? "", 
      refreshToken: map['refresh_token'] ?? "",
    );
  }

  factory LoginOutputModel.fromJson(String source) => LoginOutputModel.fromMap(jsonDecode(source));
}