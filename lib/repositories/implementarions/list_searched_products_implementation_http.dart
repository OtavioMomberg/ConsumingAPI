import 'package:http/http.dart';
import 'package:tomate_shop/models/output_models/list_searched_products.dart';
import 'package:tomate_shop/repositories/list_searched_products_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class ListSearchedProductsImplementationHttp implements ListSearchedProductsRepository {
  final Client _client;

  ListSearchedProductsImplementationHttp({required Client client}) : _client = client;

  @override
  Future<ListSearchedProducts?> listSearchedProducts(String search) async {
    try {
      final url = "$URL/api/products/name/$search";
      final response = await _client.get(
        Uri.parse(url),
        headers: {"Content-Type" : "application/json"},
      );

      if (response.statusCode == 200) {
        print("AQUI");
        print(response.body);
        return ListSearchedProducts.fromJson(response.body);
      } else {
        print("Deu RUIM");
        throw Exception(response.body);
      }
    } catch(error) {
      throw Exception(error.toString());
    }
  }

}