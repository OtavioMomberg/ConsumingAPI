import 'package:tomate_shop/models/output_models/list_searched_products.dart';
import 'package:tomate_shop/repositories/list_searched_products_repository.dart';

class ListSearchedProductsController {
  ListSearchedProductsRepository listSearchedProductsRepository;

  ListSearchedProductsController(this.listSearchedProductsRepository);

  bool _isLoading = true;

  bool get getIsLoading => _isLoading;

  String? _errorLoadProducts;

  String? get getErrorLoadProducts => _errorLoadProducts;

  ListSearchedProducts? _listSearchedProducts;

  ListSearchedProducts? get getListSearchedProducts => _listSearchedProducts;

  Future<void> onListProducts(String search) async {
    _isLoading = true;
    _errorLoadProducts = null;
    try {
      final response = await listSearchedProductsRepository.listSearchedProducts(search);

      if (response != null) _listSearchedProducts = response;
      
    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorLoadProducts = split[split.length-2];
    }
    _isLoading = false;
  }
}