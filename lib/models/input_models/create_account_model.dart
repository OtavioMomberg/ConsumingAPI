class CreateAccountModel {
  String userName;
  String email;
  String password;
  String cpf;
  Map<String, String> address;

  CreateAccountModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.cpf,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_name": userName,
      "email": email,
      "password": password,
      "cpf": cpf,
      "address": address,
    };
  }
}
