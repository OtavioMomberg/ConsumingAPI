import 'package:tomate_shop/models/output_models/list_searched_products.dart';

abstract class ListSearchedProductsRepository {
  Future<ListSearchedProducts?> listSearchedProducts(String search);
}