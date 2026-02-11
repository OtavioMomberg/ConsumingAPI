import 'package:http/http.dart';
import 'package:tomate_shop/repositories/remove_item_from_cart_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class RemoveItemFromCartImplementationHttp  implements RemoveItemFromCartRepository {
  final Client _client;

  RemoveItemFromCartImplementationHttp({required Client client}) : _client = client;

  @override
  Future<void> removeItem(int productId, String accessToken) async {
    try {
      final url = "$URL/api/orders/cart/remove/$productId";

      final response = await _client.delete(
        Uri.parse(url),
        headers: {
          "Authorization" : "Bearer $accessToken",
          "Content-Type" : "application/json",
        },
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }

    } catch(error) {
      throw Exception("Error in the operation: ${error.toString()}");
    }
  }
}