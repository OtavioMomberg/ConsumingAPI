import 'dart:convert';

class ForgotPasswordModel {
  String code;

  ForgotPasswordModel({required this.code});

  factory ForgotPasswordModel.fromMap(Map<String, dynamic> map) {
    final List<String> splitCode = map["message"].toString().split(":");
    return ForgotPasswordModel(code: splitCode.last);
  }

  factory ForgotPasswordModel.fromJson(String source) => ForgotPasswordModel.fromMap(jsonDecode(source));
}