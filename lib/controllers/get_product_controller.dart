import 'package:tomate_shop/models/output_models/get_product_model.dart';
import 'package:tomate_shop/repositories/get_product_repository.dart';

class GetProductController {
  final GetProductRepository getProductRepository;

  GetProductController(this.getProductRepository);

  String? _errorGetProduct;

  bool _isLoading = true;

  bool get getIsLoading => _isLoading;

  String? get getErrorProduct => _errorGetProduct;

  GetProductModel? _getProductModel;

  GetProductModel? get getProduct => _getProductModel;

  Future<void> getProductById(int id) async {
    _errorGetProduct = null;
    _isLoading = true;
    try {
      final response = await getProductRepository.getProduct(id);
      if (response != null) _getProductModel = response;
      
    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorGetProduct = split[split.length-2];
    }
    _isLoading = false;
  }
}