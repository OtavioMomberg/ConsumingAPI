import 'package:http/http.dart';
import 'package:tomate_shop/models/output_models/list_products_model.dart';
import 'package:tomate_shop/repositories/list_products_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class ListProductsImplementationHttp implements ListProductsRepository {
  final Client _client;

  ListProductsImplementationHttp({required Client client}) : _client = client;

  @override
  Future<ListProductsModel?> getProducts() async {
    try {
      final url = '$URL/api/products/';
      final response = await _client.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return ListProductsModel.fromJson(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch(error) {
      throw Exception(error.toString());
    }
  }
}