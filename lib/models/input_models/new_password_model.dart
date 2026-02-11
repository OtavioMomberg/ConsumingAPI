class NewPasswordModel {
  String userEmail;
  String newPassword;
  String confirmPassword;

  NewPasswordModel({
    required this.userEmail,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, String> toJson() {
    return {
      "user_email" : userEmail,
      "new_password" : newPassword,
      "confirm_password" : confirmPassword,
    };
  }
}