import 'package:tomate_shop/repositories/cancel_order_respository.dart';

class CancelOrderController {
  final CancelOrderRespository cancelOrderRespository;

  CancelOrderController(this.cancelOrderRespository);

  String? _errorCancelOrder;

  String? get getErrorCancelOrder => _errorCancelOrder;

  Future<void> onCancelOrder(String accessToken, int historyId) async {
    _errorCancelOrder = null;
    try {
      await cancelOrderRespository.cancelOrder(accessToken, historyId);

    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorCancelOrder = split[split.length-2];
    }
  }
}