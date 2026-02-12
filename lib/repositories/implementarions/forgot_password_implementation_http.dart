import 'dart:convert';
import 'package:http/http.dart';
import 'package:tomate_shop/models/output_models/forgot_password_model.dart';
import 'package:tomate_shop/repositories/forgot_password_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';
class ForgotPasswordImplementationHttp implements ForgotPasswordRepository {
  final Client _client;

  ForgotPasswordImplementationHttp({required Client client}) : _client = client;

  @override
  Future<ForgotPasswordModel?> forgotPasswordRepository(String email) async {
    try {
      final url = "$URL/api/auth/password/forgot";
      final body = jsonEncode({"user_email" : email});
      final response = await _client.post(
        Uri.parse(url),
        body: body,
        headers: {"Content-Type" : "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      } else {
        return ForgotPasswordModel.fromJson(response.body);
      }
    } catch(error) {
      throw Exception(error.toString());
    }
  }

}