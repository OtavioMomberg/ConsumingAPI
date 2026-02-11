import 'dart:convert';

class RefreshTokenModel {
  String newAccessToken;

  RefreshTokenModel({required this.newAccessToken});

  factory RefreshTokenModel.fromMap(Map<String, dynamic> map) {
    return RefreshTokenModel(newAccessToken: map["access_token"]);
  }

  factory RefreshTokenModel.fromJson(String source) => RefreshTokenModel.fromMap(jsonDecode(source));
 }