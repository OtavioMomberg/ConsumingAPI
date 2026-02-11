import 'dart:convert';
import 'package:http/http.dart';
import 'package:tomate_shop/models/input_models/verify_code_model.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';
import 'package:tomate_shop/repositories/verify_code_repository.dart';

class VerifyCodeImplementationHttp implements VerifyCodeRepository {
  final Client _client;

  VerifyCodeImplementationHttp({required Client client}) : _client = client;

  @override
  Future<void> verifyCode(VerifyCodeModel verifyCodeModel) async {
    try {
      final url = "$URL/api/auth/password/verify";
      final body = jsonEncode(verifyCodeModel.toJson());

      final response = await _client.post(
        Uri.parse(url),
        body: body,
        headers: {"Content-Type" : "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      } 
    } catch(error) {
      throw Exception("Error in the operation: ${error.toString()}");
    }
  }

} 