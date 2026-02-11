import 'package:http/http.dart';
import 'dart:convert';
import 'package:tomate_shop/models/input_models/add_product_cart_model.dart';
import 'package:tomate_shop/repositories/add_product_cart_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class AddProductCartImplementationHttp implements AddProductCartRepository {
  final Client _client;

  AddProductCartImplementationHttp({required Client client}) : _client = client;

  @override
  Future<void> addProductCart(AddProductCartModel addProductModel, String accessToken) async {
    try {
      final url = "$URL/api/orders/cart/add";
      final body = jsonEncode(addProductModel.toJson());

      final response = await _client.post(
        Uri.parse(url),
        headers: {
          "Content-Type" : "application/json",
          "Authorization" : "Bearer $accessToken",
        },
        body: body
      );

      if (response.statusCode != 200) {
        throw Exception("Error: ${response.body}");
      } 
    } catch(error) {
      throw Exception("Error in the operation: ${error.toString()}");
    }
  } 

}