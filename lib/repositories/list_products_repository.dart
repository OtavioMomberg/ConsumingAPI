import '../models/output_models/list_products_model.dart';

abstract class ListProductsRepository {
  Future<ListProductsModel?> getProducts();
}