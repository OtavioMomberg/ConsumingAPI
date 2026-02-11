class VerifyCodeModel {
  String userEmail;
  String code;

  VerifyCodeModel({
    required this.userEmail,
    required this.code,
  });

  Map<String, String> toJson() {
    return {
      "user_email" : userEmail,
      "code" : code,
    };
  }
}