import 'package:http/http.dart';
import 'package:tomate_shop/models/output_models/get_product_model.dart';
import 'package:tomate_shop/repositories/get_product_repository.dart';
import 'package:tomate_shop/repositories/routes/api_route.dart';

class GetProductImplementationHttp implements GetProductRepository {
  final Client _client;

  GetProductImplementationHttp({required Client client}) : _client = client;

  @override
  Future<GetProductModel?> getProduct(int id) async {
    try {
      final url = "$URL/api/products/$id";
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return GetProductModel.fromJson(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch(error) {
      throw Exception("Error in the operation: ${error.toString()}");
    }
  }

}