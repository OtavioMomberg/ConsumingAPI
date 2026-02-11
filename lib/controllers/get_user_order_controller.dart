import 'package:tomate_shop/models/output_models/get_user_order_model.dart';
import 'package:tomate_shop/repositories/get_user_order_repository.dart';

class GetUserOrderController {
  final GetUserOrderRepository getUserOrderRepository;

  GetUserOrderController(this.getUserOrderRepository);

  String? _errorGetOrder;

  String? get getErrorOrder => _errorGetOrder;

  bool _isLoading = true;

  bool get getIsLoading => _isLoading;

  GetUserOrderModel? _userOrderModel;

  GetUserOrderModel? get getUserOrderModel => _userOrderModel;

  Future<void> onGetOrder(String accessToken, int historyId) async {
    _errorGetOrder = null;
    _isLoading = true;
    try {
      final response = await getUserOrderRepository.getUniqueOrder(accessToken, historyId);

      if (response != null) _userOrderModel = response;
    

    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorGetOrder = split[split.length-2];
    }
    _isLoading = false;
  }
}