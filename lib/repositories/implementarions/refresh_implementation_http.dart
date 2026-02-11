import 'package:http/http.dart';
import 'package:tomate_shop/models/output_models/refresh_token_model.dart';
import 'package:tomate_shop/repositories/refresh_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class RefreshImplementationHttp implements RefreshRepository {
  final Client _client;

  RefreshImplementationHttp({required Client client}) : _client = client;

  @override
  Future<RefreshTokenModel?> getNewAccessToken(String refreshToken) async {
    try {
      final url = "$URL/api/auth/refresh";
      final response = await _client.get(
        Uri.parse(url), 
        headers: {
          "Authorization" : "Bearer $refreshToken",
        }
      );

      if (response.statusCode == 200) {
        return RefreshTokenModel.fromJson(response.body);
      } else {
        throw Exception("Error in the request. You must be logged in to take a new token.|");
      }

    } catch(error) {
      throw Exception("Error in the request. Error: ${error.toString()}");
    }
  }

}