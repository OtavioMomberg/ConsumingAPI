import 'package:tomate_shop/models/output_models/list_orders_model.dart';

abstract class ListOrdersRepository {
  Future<ListOrdersModel?> getOrders(String accessToken);
}