import 'package:http/http.dart';
import 'dart:convert';
import 'package:tomate_shop/models/input_models/create_account_model.dart';
import 'package:tomate_shop/repositories/create_account_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class CreateAccountImplementationHttp implements CreateAccountRepository {
  final Client _client;

  CreateAccountImplementationHttp({required Client client}) : _client = client;
  @override
  Future<void> registerAccount(CreateAccountModel createAccountModel) async {
    try {
      final url = '$URL/api/auth/register';
      final body = jsonEncode(createAccountModel.toJson());
      
      final response = await _client.post(
        Uri.parse(url), 
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode != 201) {
        throw Exception(response.body);
      }
    } catch(error) {
      throw Exception("Error in the operation: ${error.toString()}");
    }
  }
}