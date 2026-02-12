import 'package:http/http.dart';
import 'dart:convert';
import 'package:tomate_shop/models/input_models/update_cart_product_model.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';
import 'package:tomate_shop/repositories/update_cart_product_repository.dart';

class UpdateCartProductImplementationHttp implements UpdateCartProductRepository {
  final Client _client;

  UpdateCartProductImplementationHttp({required Client client}) : _client = client; 

  @override
  Future<void> updateCartProduct(UpdateCartProductModel updateCartProductModel, String accessToken) async {
    try {
      final url = "$URL/api/orders/cart/update";
      final body = jsonEncode(updateCartProductModel.toJson());

      final response = await _client.patch(
        Uri.parse(url),
        headers: {
          "Authorization" : "Bearer $accessToken",
          "Content-Type" : "application/json",
        },
        body: body,
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      } 

    } catch (error) {
      throw Exception(error.toString());
    }
  }

}