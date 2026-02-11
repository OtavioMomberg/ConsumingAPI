import 'package:http/http.dart';
import 'package:tomate_shop/repositories/cancel_order_respository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class CancelOrderImplementationHttp implements CancelOrderRespository {
  final Client _client;

  CancelOrderImplementationHttp({required Client client}) : _client = client;

  @override
  Future<void> cancelOrder(String accessToken, int historyId) async {
    try {
      final url = "$URL/api/orders/cancel_order/$historyId";
      final response = await _client.post(
        Uri.parse(url),
        headers: {"Authorization" : "Bearer $accessToken"},
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }

    } catch(error) {
      throw Exception("Error in the operation: ${error.toString()}");
    }
  }

} 