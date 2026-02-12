import 'package:http/http.dart';
import 'dart:convert';
import 'package:tomate_shop/models/input_models/update_user_model.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';
import 'package:tomate_shop/repositories/update_user_repository.dart';

class UpdateUserImplementationHttp implements UpdateUserRepository {
  final Client _client;

  UpdateUserImplementationHttp({required Client client}) : _client = client;
 
  @override
  Future<void> updateUser(String accessToken, UpdateUserModel updateUserModel) async {
    try {
      final url = "$URL/api/users/update";
      final body = jsonEncode(updateUserModel.toJson());

      final response = await _client.put(
        Uri.parse(url),
        body: body,
        headers: {
          "Authorization" : "Bearer $accessToken",
          "Content-Type" : "application/json",
        },
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }

    } catch(error) {
      throw Exception(error.toString());
    }
  }

}