import 'package:tomate_shop/models/input_models/add_product_cart_model.dart';

abstract class AddProductCartRepository {
  Future<void> addProductCart(AddProductCartModel addProductModel, String accessToken); 
}