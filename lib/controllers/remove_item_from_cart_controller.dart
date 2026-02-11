import 'package:tomate_shop/repositories/remove_item_from_cart_repository.dart';

class RemoveItemFromCartController {
  final RemoveItemFromCartRepository removeItemFromCartRepository;

  RemoveItemFromCartController(this.removeItemFromCartRepository);

  String? _errorRemoveItem;

  String? get getErrorRemoveItem => _errorRemoveItem;

  Future<void> onRemoveItem(int productId, String accessToken) async {
    _errorRemoveItem = null;
    try {
      await removeItemFromCartRepository.removeItem(productId, accessToken);

    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorRemoveItem = split[split.length-2];
    }
  }
}