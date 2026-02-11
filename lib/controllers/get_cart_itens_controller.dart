import 'package:tomate_shop/models/output_models/get_cart_itens_model.dart';
import 'package:tomate_shop/repositories/get_cart_itens_repository.dart';

class GetCartItensController {
  final GetCartItensRepository getCartItensRepository;

  GetCartItensController(this.getCartItensRepository);

  String? _errorGetCartItens;

  String? get getErrorCartItens => _errorGetCartItens;

  bool _loadingItens = true;

  bool get getLoadingItens => _loadingItens;

  GetCartItensModel? _cartItens;

  GetCartItensModel? get getCartItens => _cartItens;

  Future<void> onGetCartItens(String accessToken) async {
    _errorGetCartItens = null;
    _loadingItens = true;
    try {
      final response = await getCartItensRepository.getCartItens(accessToken);

      if (response != null) _cartItens = response;
      
    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorGetCartItens = split[split.length-2];
    }
    _loadingItens = false;
  }
}