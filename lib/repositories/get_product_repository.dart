import 'package:tomate_shop/models/output_models/get_product_model.dart';

abstract class GetProductRepository {
  Future<GetProductModel?> getProduct(int id);
}