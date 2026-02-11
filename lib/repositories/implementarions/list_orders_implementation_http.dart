import 'package:http/http.dart';
import 'package:tomate_shop/models/output_models/list_orders_model.dart';
import 'package:tomate_shop/repositories/list_orders_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class ListOrdersImplementationHttp implements ListOrdersRepository {
  final Client _client;

  ListOrdersImplementationHttp({required Client client}) : _client = client;

  @override
  Future<ListOrdersModel?> getOrders(String accessToken) async {
    try {
      final url = "$URL/api/orders/";
      final response = await _client.get(
        Uri.parse(url),
        headers: {"Authorization" : "Bearer $accessToken"}
      );

      if (response.statusCode == 200) {
        return ListOrdersModel.fromJson(response.body);
      } else {
        throw Exception(response.body);
      }

    } catch(error) {
      throw Exception(error.toString());
    }
  }

}