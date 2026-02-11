import 'package:http/http.dart';
import 'package:tomate_shop/models/output_models/get_user_model.dart';
import 'package:tomate_shop/repositories/get_user_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class GetUserImplementationHttp implements GetUserRepository {
  final Client _client;

  GetUserImplementationHttp({required Client client}) : _client = client;

  @override
  Future<GetUserModel?> getUser(String accessToken) async {
    try {
      final url = "$URL/api/users/unique";
      final response = await _client.get(
        Uri.parse(url),
        headers: {"Authorization" : "Bearer $accessToken"}
      );

      if (response.statusCode == 200) {
        return GetUserModel.fromJson(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch(error) {
      throw Exception("Error in the operation: ${error.toString()}");
    }
  }

} 