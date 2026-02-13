import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tomate_shop/auth/auth_services.dart';
import 'package:tomate_shop/auth/verify_tokens.dart';
import 'package:tomate_shop/controllers/get_user_order_controller.dart';
import 'package:tomate_shop/enums/auth_enum.dart';
import 'package:tomate_shop/enums/token_type_enum.dart';
import 'package:tomate_shop/repositories/implementarions/get_user_order_implementation_http.dart';
import 'package:intl/intl.dart';
import 'package:tomate_shop/widgets/cards/card_detail_order.dart';

class OrderPage extends StatefulWidget {
  final int historyId;
  const OrderPage({required this.historyId, super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late final GetUserOrderController getUserOrderController;
  final VerifyTokens _verifyTokens = VerifyTokens();
  late String? token;
  final AuthServices _authServices = AuthServices();
  late String _auth;

  @override
  void initState() {
    super.initState();

    getUserOrderController = GetUserOrderController(
      GetUserOrderImplementationHttp(client: Client()),
    );

    loadOrder();
  }

  Future<void> loadOrder() async {
    _auth = await _verifyTokens.checkAccessToken(TokenTypeEnum.mapper(TokenType.accessToken));

    if (_auth == MapAuthEnum.mapper(AuthEnum.authenticated)) {
      token = await _authServices.getToken(TokenTypeEnum.mapper(TokenType.accessToken));
      await getUserOrderController.onGetOrder(token!, widget.historyId);
    } else {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 240, 174),
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.all(10),
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
      child: getUserOrderController.getIsLoading 
        ? Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
        : getUserOrderController.getErrorOrder == null 
          ? Container(
            height: size.height * 0.9,
            width: size.width * 0.8,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
              ),
              color: Colors.white.withValues(alpha: 0.1),
            ),
            child: Column(
                children: <Widget>[
                  Text(
                    "${getUserOrderController.getUserOrderModel?.order["name"].toString().toUpperCase() ?? ""} ",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Final Price: R\$ ${getUserOrderController.getUserOrderModel?.order["final_price"] ?? 0.0}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), 
                  ),
                  Text(
                    getUserOrderController.getUserOrderModel?.order['order_finished_time'] != null 
                      ? "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(getUserOrderController.getUserOrderModel?.order['order_finished_time']))}"
                      : "",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: getUserOrderController.getUserOrderModel?.order["products"].length ?? 0,
                      itemBuilder: (context, index) {
                        return CardDetailOrder(
                          productName: getUserOrderController.getUserOrderModel?.order["products"][index]["product_name"] ?? "", 
                          quantity: getUserOrderController.getUserOrderModel?.order["products"][index]["quantity"].toString() ?? "0", 
                          totalPrice: getUserOrderController.getUserOrderModel?.order["products"][index]["total_price"].toString() ?? "0.0", 
                          unitaryPrice: getUserOrderController.getUserOrderModel?.order["products"][index]["unitary_price"].toString() ?? "0.0",
                        );
                      }
                    ),
                  ),
                  Text(
                    "Status: ${getUserOrderController.getUserOrderModel?.order["status"] ?? ""}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getUserOrderController.getUserOrderModel?.order['cancel_time'] != null 
                      ? "Cancel Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(getUserOrderController.getUserOrderModel?.order['cancel_time']))}"
                      : "",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Modifier: ${getUserOrderController.getUserOrderModel?.order["modifier"].toString().toUpperCase() ?? ""}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          )
          : Center(
              child: Text(
                getUserOrderController.getErrorOrder!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
    );
  }
}