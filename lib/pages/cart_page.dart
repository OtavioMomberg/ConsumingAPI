import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tomate_shop/auth/auth_services.dart';
import 'package:tomate_shop/auth/verify_tokens.dart';
import 'package:tomate_shop/controllers/finish_order_controller.dart';
import 'package:tomate_shop/controllers/get_cart_itens_controller.dart';
import 'package:tomate_shop/controllers/remove_item_from_cart_controller.dart';
import 'package:tomate_shop/controllers/update_cart_product_controller.dart';
import 'package:tomate_shop/enums/auth_enum.dart';
import 'package:tomate_shop/enums/token_type_enum.dart';
import 'package:tomate_shop/models/input_models/update_cart_product_model.dart';
import 'package:tomate_shop/pages/product_page.dart';
import 'package:tomate_shop/repositories/implementarions/finish_order_implementation_http.dart';
import 'package:tomate_shop/repositories/implementarions/remove_item_from_cart_implementation_http.dart';
import 'package:tomate_shop/repositories/implementarions/get_cart_itens_implementation_http.dart';
import 'package:tomate_shop/repositories/implementarions/update_cart_product_implementation_http.dart';
import 'package:tomate_shop/widgets/buttons/button.dart';
import 'package:tomate_shop/widgets/cards/card_cart_product.dart';
import 'package:tomate_shop/widgets/select_quantity.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  late final GetCartItensController _getCartItensController;
  late final RemoveItemFromCartController _removeItemFromCartController;
  late final UpdateCartProductController _updateCartProductController;
  late final FinishOrderController _finishOrderController;
  final VerifyTokens _verifyTokens = VerifyTokens();
  late final AuthServices _authServices;
  late int listSize;
  late String? token;
  late String? _auth;
  double price = 0.0;
  int finalQuantity = 0;
  bool ignoreButton = false;

  @override
  void initState() {
    super.initState();

    _authServices = AuthServices();

    _getCartItensController = GetCartItensController(
      GetCartItensImplementationHttp(client: Client()),
    );

    _removeItemFromCartController = RemoveItemFromCartController(
      RemoveItemFromCartImplementationHttp(client: Client()),
    );

    _finishOrderController = FinishOrderController(
      FinishOrderImplementationHttp(client: Client()),
    );

    _updateCartProductController = UpdateCartProductController(
      UpdateCartProductImplementationHttp(client: Client()),
    );

    loadItens();
  }

  Future<void> loadItens() async {
    _auth = await _verifyTokens.checkAccessToken(
      TokenTypeEnum.mapper(TokenType.accessToken),
    );

    if (_auth == MapAuthEnum.mapper(AuthEnum.authenticated)) {
      token = await _authServices.getToken(
        TokenTypeEnum.mapper(TokenType.accessToken),
      );
      await _getCartItensController.onGetCartItens(token!);
    } else {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      child: _getCartItensController.getLoadingItens
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : _getCartItensController.getErrorCartItens == null
          ? Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        _getCartItensController
                            .getCartItens
                            ?.cartDetails['cart_products']
                            .length ??
                        0,
                    itemBuilder: (context, index) {
                      return FractionallySizedBox(
                        widthFactor: 0.9,
                        child: CardCartProduct(
                          index: index,
                          title: _getCartItensController.getCartItens?.cartDetails['cart_products'][index]['product_name'] ?? "",
                          totalPrice: _getCartItensController.getCartItens?.cartDetails['cart_products'][index]['total_price'] ?? 0,
                          quantity: _getCartItensController.getCartItens?.cartDetails['cart_products'][index]['quantity'] ?? 0,
                          productId: _getCartItensController.getCartItens?.cartDetails['cart_products'][index]['id'] ?? -1,
                          openProductPage: _productPage,
                          updateProduct: _updateItem,
                          removeProduct: _removeItem,
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  price > 0.0
                      ? "Final Price: R\$ ${((_getCartItensController.getCartItens?.cartDetails['final_price'] ?? 0.0) - price)}"
                      : _getCartItensController.getCartItens?.cartDetails['cart_products'].length > 0
                      ? "Final Price: R\$ ${(_getCartItensController.getCartItens?.cartDetails['final_price'] ?? 0)}"
                      : "Final Price: R\$ 0",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: IgnorePointer(
                    ignoring: _getCartItensController.getCartItens?.cartDetails['cart_products'].length == 0
                      ? true
                      : false,
                    child: Button(
                      buttonText: "Finish Order",
                      function: _finishOrder,
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Text(_getCartItensController.getErrorCartItens!),
            ),
    );
  }

  void _productPage(int index) {
    if (_getCartItensController.getCartItens?.cartDetails['cart_products'][index]['id'] == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ProductPage(
            id: _getCartItensController.getCartItens?.cartDetails['cart_products'][index]['id'],
          );
        },
      ),
    ).then((_) => loadItens());
  }

  Future<bool> checkAuth() async {
    _auth = await _verifyTokens.checkAccessToken(
      TokenTypeEnum.mapper(TokenType.accessToken),
    );

    return _auth == MapAuthEnum.mapper(AuthEnum.notAuthenticated) ? false : true;
  }

  Future<void> _removeItem(int id, int index) async {
    final check = await checkAuth();

    if (!check) return;

    String? accessToken = await _authServices.getToken(TokenTypeEnum.mapper(TokenType.accessToken));

    price = _getCartItensController.getCartItens?.cartDetails['cart_products'][index]['total_price'];

    final itemErased = _getCartItensController.getCartItens?.cartDetails['cart_products'].removeAt(index);

    if (_getCartItensController.getCartItens?.cartDetails['cart_products'].length == 0) {
      price = 0.0;
    }

    setState(() {});

    await _removeItemFromCartController.onRemoveItem(id, accessToken!);

    price = 0.0;

    if (_removeItemFromCartController.getErrorRemoveItem != null) {
      _getCartItensController.getCartItens?.cartDetails['cart_products'].insert(index, itemErased);
      _showMessage("Error", _removeItemFromCartController.getErrorRemoveItem!);
      setState(() {});
    }
  }

  Future<void> _updateItem(int productId, int index) async {
    final check = await checkAuth();

    if (!check) return;

    String? accessToken = await _authServices.getToken(TokenTypeEnum.mapper(TokenType.accessToken));

    finalQuantity = await _getQuantity(_getCartItensController.getCartItens?.cartDetails['cart_products'][index]['quantity']);

    if (finalQuantity < 0) return;

    if (finalQuantity == 0) {
      _showMessage("Error", "Invalid Value. You must provide a number greater than 0.");
      return;
    }
    
    final UpdateCartProductModel updateCartProductModel = UpdateCartProductModel(
      productId: productId, 
      quantity: finalQuantity
    );

    await _updateCartProductController.onUpdateCartProduct(updateCartProductModel, accessToken!);

    setState(() => loadItens());

    if (_updateCartProductController.getErrorUpdateCartProduct != null) {
      _showMessage("Error", _updateCartProductController.getErrorUpdateCartProduct!);
      return;
    }
  }

  Future<int> _getQuantity(int quantity) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              setState(() => finalQuantity = -1);
              Navigator.pop(context);
            },
            child: Text("Cancel", style: TextStyle(color: Color.fromARGB(255, 254, 160, 109))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: Color.fromARGB(255, 254, 160, 109))),
          ),
        ],
        title: Center(
          child: const Text("Remove Item", style: TextStyle(color: Color.fromARGB(255, 254, 160, 109))),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: <Widget>[
            const Text("Select the quantity to remove:", style: TextStyle(color: Color.fromARGB(255, 254, 160, 109))),
            SelectQuantity(
              stockQuantity: quantity,
              onChanged: (value) => setState(() => finalQuantity = value),
            ),
          ],
        ),
      ),
    );
    return finalQuantity;
  }

  Future<void> _finishOrder() async {
    final check = await checkAuth();

    if (!check) {
      await _showMessage("Error", "You must be logged in to continue.");
      return;
    }

    final String? accessToken = await _authServices.getToken(
      TokenTypeEnum.mapper(TokenType.accessToken),
    );
    await _finishOrderController.onFinishOrder(accessToken!);

    if (_finishOrderController.getErrorFinishOrder == null) {
      await _showMessage("Order Ended!", "You can cancel your order in maximum 1 day");
      _removeAllItens();
      setState(() {});
    } else {
      await _showMessage("Error", _finishOrderController.getErrorFinishOrder!);
    }
  }

  void _removeAllItens() {
    _getCartItensController.getCartItens?.cartDetails['cart_products'].clear();
    setState(() {});
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
