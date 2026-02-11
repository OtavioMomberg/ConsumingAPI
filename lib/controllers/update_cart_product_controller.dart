import 'package:tomate_shop/models/input_models/update_cart_product_model.dart';
import 'package:tomate_shop/repositories/update_cart_product_repository.dart';

class UpdateCartProductController {
  final UpdateCartProductRepository updateCartProductRepository;

  UpdateCartProductController(this.updateCartProductRepository);

  String? _errorUpdateCartProduct;

  String? get getErrorUpdateCartProduct => _errorUpdateCartProduct;

  Future<void> onUpdateCartProduct(UpdateCartProductModel updateCartProductModel, String accessToken) async {
    _errorUpdateCartProduct = null;
    try {
      await updateCartProductRepository.updateCartProduct(updateCartProductModel, accessToken);

    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorUpdateCartProduct = split[split.length-2];
    }
  }
}