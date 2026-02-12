import 'package:http/http.dart';
import 'dart:convert';
import 'package:tomate_shop/models/input_models/new_password_model.dart';
import 'package:tomate_shop/repositories/new_password_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class NewPasswordImplementationHttp implements NewPasswordRepository {
  final Client _client;

  NewPasswordImplementationHttp({required Client client}) : _client = client;

  @override
  Future<void> newPassword(NewPasswordModel newPasswordModel) async {
    try {
      final url = "$URL/api/auth/password/reset";
      final body = jsonEncode(newPasswordModel.toJson());

      final response = await _client.post(
        Uri.parse(url),
        body: body,
        headers: {"Content-Type" : "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
    } catch(error) {
      throw Exception(error.toString());
    }
  }

}