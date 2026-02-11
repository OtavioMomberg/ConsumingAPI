import 'dart:convert';

class GetUserModel {
  Map<String, dynamic> user;

  GetUserModel({required this.user});

  factory GetUserModel.fromMap(Map<String, dynamic> map) {
    return GetUserModel(user: map);
  } 

  factory GetUserModel.fromJson(String source) => GetUserModel.fromMap(jsonDecode(source));
}