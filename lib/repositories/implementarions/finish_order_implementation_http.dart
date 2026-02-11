import 'package:http/http.dart';
import 'package:tomate_shop/repositories/finish_order_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class FinishOrderImplementationHttp implements FinishOrdemRepository {
  final Client _client;

  FinishOrderImplementationHttp({required Client client}) : _client = client;

  @override
  Future<void> finishOrder(String accessToken) async {
    try {
      final url = "$URL/api/orders/finish_order";
      final response = await _client.post(
        Uri.parse(url),
        headers: {"Authorization" : "Bearer $accessToken"}
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
    } catch(error) {
      throw Exception("Error in the operarion: ${error.toString()}");
    }
  }

}