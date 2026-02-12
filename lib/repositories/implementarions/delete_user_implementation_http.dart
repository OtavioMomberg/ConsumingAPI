import 'package:http/http.dart';
import 'package:tomate_shop/repositories/delete_user_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class DeleteUserImplementationHttp implements DeleteUserRepository {
  final Client _client;

  DeleteUserImplementationHttp({required Client client}) : _client = client;

  @override
  Future<void> deleteUser(String accessToken) async {
    try {
      final url = "$URL/api/users/delete";
      final response = await _client.delete(
        Uri.parse(url),
        headers: {"Authorization" : "Bearer $accessToken"},
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      } 

    } catch(error) {
      throw Exception(error.toString());
    }
  }

}