import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tomate_shop/auth/auth_services.dart';
import 'package:tomate_shop/auth/verify_tokens.dart';
import 'package:tomate_shop/controllers/cancel_order_controller.dart';
import 'package:tomate_shop/controllers/list_orders_controller.dart';
import 'package:tomate_shop/enums/auth_enum.dart';
import 'package:tomate_shop/enums/token_type_enum.dart';
import 'package:tomate_shop/pages/order_page.dart';
import 'package:tomate_shop/repositories/implementarions/cancel_order_implementation_http.dart';
import 'package:tomate_shop/repositories/implementarions/list_orders_implementation_http.dart';
import 'package:tomate_shop/widgets/cards/card_orders.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
  late final ListOrdersController listOrdersController;
  late final CancelOrderController cancelOrderController;
  final VerifyTokens _verifyTokens = VerifyTokens();
  late final AuthServices _authServices;
  late int listSize;
  late String? token;
  late String? _auth;

  @override
  void initState() {
    super.initState();

    _authServices = AuthServices();

    listOrdersController = ListOrdersController(
      ListOrdersImplementationHttp(client: Client()),
    );

    cancelOrderController = CancelOrderController(
      CancelOrderImplementationHttp(client: Client()),
    );

    loadOrders();
  }

  Future<bool> checkToken() async {
    _auth = await _verifyTokens.checkAccessToken(TokenTypeEnum.mapper(TokenType.accessToken));

    if (_auth == MapAuthEnum.mapper(AuthEnum.authenticated)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> loadOrders() async {
    final check = await checkToken();

    if (check) {
      token = await _authServices.getToken(TokenTypeEnum.mapper(TokenType.accessToken));
      await listOrdersController.onListOrders(token!);
      setState(() {});
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 240, 174),
        surfaceTintColor: Colors.transparent,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(bottom: 95),
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Color.fromARGB(255, 255, 240, 174),
            Color.fromARGB(255, 249, 169, 125),
            Color.fromARGB(255, 254, 160, 109),
          ],
        ),
      ),
      child: listOrdersController.getIsLoading
        ? Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
        : listOrdersController.getErrorListOrders == null
          ? Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: listOrdersController.getListOrdersModel?.orders.length ?? 0,
                    itemBuilder: (context, index) {
                      return FractionallySizedBox(
                        widthFactor: 0.9,
                        child: CardOrders(
                          name: listOrdersController.getListOrdersModel?.orders[index]['name'].toString().toUpperCase() ?? "", 
                          finalPrice: listOrdersController.getListOrdersModel?.orders[index]['final_price'].toString() ?? "0", 
                          time: DateFormat('dd/MM/yyyy').format(DateTime.parse(listOrdersController.getListOrdersModel?.orders[index]['order_finished_time'])).toString(), 
                          status: listOrdersController.getListOrdersModel?.orders[index]['status'] ?? "", 
                          historyId: listOrdersController.getListOrdersModel?.orders[index]['history_id'], 
                          orderPage: _goToOrderPage, 
                          cancelOrder: _manageCancelOrder,
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                listOrdersController.getErrorListOrders!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
  
  void _goToOrderPage(int? historyId) {
    if (historyId == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return OrderPage(historyId: historyId);
      }),
    );
  }

  Future<void> _manageCancelOrder(int? historyId) async {
    bool? response = await _confirmCanceling();

    if (response == null || response == false) return;

    if (historyId == null) return;
                              
    await _cancelUserOrder(historyId);

    if (cancelOrderController.getErrorCancelOrder == null) {
      _showMessage("Success", "Order canceled successfully");
    } else {
      _showMessage("Error", cancelOrderController.getErrorCancelOrder!);
    }
                            
    setState(() => response = null);
  }

  Future<bool?> _confirmCanceling() async {
    bool? value;
    await showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: const Text("Are you sure you'd like to cancel this order?", style: TextStyle(color: Color.fromARGB(255, 254, 160, 109))),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              onPressed: () {
                value = true;
                Navigator.pop(context);
              },
              child: const Text("YES", style: TextStyle(color: Color.fromARGB(255, 254, 160, 109)))
            ),
            TextButton(
              onPressed: () {
                value = false;
                Navigator.pop(context);
              },
              child: const Text("NO", style: TextStyle(color: Color.fromARGB(255, 254, 160, 109)))
            ),
          ],
        ),
      ),
    );
    return value;
  }
  
  Future<void> _cancelUserOrder(int historyId) async {
    final check = await checkToken();

    if (check) {
      token = await _authServices.getToken(TokenTypeEnum.mapper(TokenType.accessToken));
      await cancelOrderController.onCancelOrder(token!, historyId);
      setState(() {});
    } else {
      _showMessage("Error", "You must be logged in to cancel the order");
      return;
    }
  }

  Future<void> _showMessage(String title, String content) async {
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: const TextStyle(color: Color.fromARGB(255, 254, 160, 109))),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, color: const Color.fromARGB(255, 254, 160, 109)),
            ),
          ],
        ),
        content: Text(content, style: const TextStyle(color: Color.fromARGB(255, 254, 160, 109))),
      ),
    );
  }
}
