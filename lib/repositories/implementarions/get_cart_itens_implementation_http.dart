import 'package:http/http.dart';
import 'package:tomate_shop/models/output_models/get_cart_itens_model.dart';
import 'package:tomate_shop/repositories/get_cart_itens_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class GetCartItensImplementationHttp implements GetCartItensRepository {
  final Client _client;

  GetCartItensImplementationHttp({required Client client}) : _client = client;

  @override
  Future<GetCartItensModel?> getCartItens(String accessToken) async {
    try {
      final url = "$URL/api/orders/cart";
      final response = await _client.get(
        Uri.parse(url),
        headers: {"Authorization" : "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        return GetCartItensModel.fromJson(response.body);
      } else {
        throw Exception(response.body);
      }

    } catch(error) {
      throw Exception("Error in the operation: ${error.toString()}");
    }
  }

}