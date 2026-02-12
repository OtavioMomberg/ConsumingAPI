import 'package:http/http.dart';
import 'package:tomate_shop/models/output_models/get_user_order_model.dart';
import 'package:tomate_shop/repositories/get_user_order_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class GetUserOrderImplementationHttp implements GetUserOrderRepository {
  final Client _client;

  GetUserOrderImplementationHttp({required Client client}) : _client = client;

  @override
  Future<GetUserOrderModel?> getUniqueOrder(String accessToken, int historyId) async {
    try {
      final url = "$URL/api/orders/$historyId";
      final response = await _client.get(
        Uri.parse(url),
        headers: {"Authorization" : "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        return GetUserOrderModel.fromJson(response.body);
      } else {
        throw Exception(response.body);
      }

    } catch(error) {
      throw Exception(error.toString());
    }
  }

}