import '../models/output_models/get_user_order_model.dart';

abstract class GetUserOrderRepository {
  Future<GetUserOrderModel?> getUniqueOrder(String accessToken, int historyId); 
}