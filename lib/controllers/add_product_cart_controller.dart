import 'package:tomate_shop/models/input_models/add_product_cart_model.dart';
import 'package:tomate_shop/repositories/add_product_cart_repository.dart';

class AddProductCartController {
  AddProductCartRepository addProductCartRepository;

  AddProductCartController(this.addProductCartRepository);

  String? _errorAddProduct;

  String? get getErrorAddProduct => _errorAddProduct;

  Future<void> addProductCart(AddProductCartModel addProductModel, String accessToken) async {
    _errorAddProduct = null;
    try {
      await addProductCartRepository.addProductCart(addProductModel, accessToken);
    } catch(error) {
      _errorAddProduct = "Error in the operation: ${error.toString()}";
    }
  }
 
}