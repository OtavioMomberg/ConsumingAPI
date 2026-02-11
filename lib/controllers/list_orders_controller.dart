import 'package:tomate_shop/models/output_models/list_orders_model.dart';
import 'package:tomate_shop/repositories/list_orders_repository.dart';

class ListOrdersController {
  final ListOrdersRepository listOrdersRepository;

  ListOrdersController(this.listOrdersRepository);

  String? _errorListOrders;

  String? get getErrorListOrders => _errorListOrders;

  bool _isLoading = true;

  bool get getIsLoading => _isLoading;

  ListOrdersModel? _listOrdersModel;

  ListOrdersModel? get getListOrdersModel => _listOrdersModel;

  Future<void> onListOrders(String accessToken) async {
    _errorListOrders = null;
    _isLoading = true;
    try {
      final response = await listOrdersRepository.getOrders(accessToken);

      if (response != null) {
        _listOrdersModel = response;
      }

    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorListOrders = split[split.length-2];
    }
    _isLoading = false;
  }
}