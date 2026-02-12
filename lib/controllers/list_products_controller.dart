import 'package:tomate_shop/models/output_models/list_products_model.dart';
import 'package:tomate_shop/repositories/list_products_repository.dart';

class ListProductsController {
  final ListProductsRepository listProductsRepository;

  ListProductsController(this.listProductsRepository);

  bool _loadProducts = true;

  bool get getLoadProducts => _loadProducts;

  String? _errorLoadProducts;

  String? get getErrorLoadProducts => _errorLoadProducts;

  ListProductsModel? _listProductsModel;

  ListProductsModel? get getListProductsModel => _listProductsModel;

  Future<void> onListProducts() async {
    _loadProducts = true;
    _errorLoadProducts = null;
    try { 
      final response = await listProductsRepository.getProducts();

      if (response != null) _listProductsModel = response;
      
    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorLoadProducts = split[split.length-2];
    }
    _loadProducts = false;
  }
}