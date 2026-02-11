import 'package:tomate_shop/repositories/finish_order_repository.dart';

class FinishOrderController {
  final FinishOrdemRepository finishOrdemRepository;

  FinishOrderController(this.finishOrdemRepository);

  String? _errorFinishOrder;

  String? get getErrorFinishOrder => _errorFinishOrder;

  Future<void> onFinishOrder(String accessToken) async {
    _errorFinishOrder = null;
    try {
      await finishOrdemRepository.finishOrder(accessToken);
    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorFinishOrder = split[split.length-2];
    }
  }
}