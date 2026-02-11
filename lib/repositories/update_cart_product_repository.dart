import 'package:tomate_shop/models/input_models/update_cart_product_model.dart';

abstract class UpdateCartProductRepository {
  Future<void> updateCartProduct(UpdateCartProductModel updateCartProductModel, String accessToken);
}