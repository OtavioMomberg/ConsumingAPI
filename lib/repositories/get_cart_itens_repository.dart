import 'package:tomate_shop/models/output_models/get_cart_itens_model.dart';

abstract class GetCartItensRepository {
  Future<GetCartItensModel?> getCartItens(String accessToken);
}