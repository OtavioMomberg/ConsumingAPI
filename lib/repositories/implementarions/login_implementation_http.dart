import 'dart:convert';
import 'package:http/http.dart';
import 'package:tomate_shop/models/input_models/login_model.dart';
import 'package:tomate_shop/models/output_models/login_output_model.dart';
import 'package:tomate_shop/repositories/login_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class LoginImplementationHttp implements LoginRepository {
  final Client _client;

  LoginImplementationHttp({required Client client}) : _client = client;

  @override
  Future<LoginOutputModel?> loginUser(LoginModel loginModel) async {
    try {
      final url = '$URL/api/auth/login';
      final body = jsonEncode(loginModel.toJson());

      final response = await _client.post(
        Uri.parse(url), 
        headers: {"Content-Type" : "application/json"},
        body: body,
      );
      if (response.statusCode != 200) {
        throw Exception(response.body);
      } else {
        return LoginOutputModel.fromJson(response.body);
      }
    } catch(error) {
      throw Exception(error.toString());
    }
  }

}