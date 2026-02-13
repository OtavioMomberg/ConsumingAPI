import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tomate_shop/auth/auth_services.dart';
import 'package:tomate_shop/auth/verify_tokens.dart';
import 'package:tomate_shop/controllers/add_product_cart_controller.dart';
import 'package:tomate_shop/controllers/get_product_controller.dart';
import 'package:tomate_shop/enums/auth_enum.dart';
import 'package:tomate_shop/enums/token_type_enum.dart';
import 'package:tomate_shop/models/input_models/add_product_cart_model.dart';
import 'package:tomate_shop/repositories/implementarions/add_product_cart_implementation_http.dart';
import 'package:tomate_shop/repositories/implementarions/get_product_implementation_http.dart';
import 'package:tomate_shop/widgets/buttons/button.dart';
import 'package:tomate_shop/widgets/cards/card_product_detail.dart';
import 'package:tomate_shop/widgets/select_quantity.dart';
import 'login_page.dart';

class ProductPage extends StatefulWidget {
  final int id;
  const ProductPage({required this.id, super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final VerifyTokens _verifyTokens = VerifyTokens();
  late final GetProductController getProductController;
  late final AddProductCartController addProductCartController;
  final String token = TokenTypeEnum.mapper(TokenType.accessToken);
  late final AuthServices _authServices;
  late String _auth;
  int selectedQuantity = 0;

  @override
  void initState() {
    super.initState();
    
    _authServices = AuthServices();

    getProductController = GetProductController(
      GetProductImplementationHttp(client: Client()),
    );

    addProductCartController = AddProductCartController(
      AddProductCartImplementationHttp(client: Client()),
    );

    _loadProduct();
  }

  Future<void> _loadProduct() async {
    await getProductController.getProductById(widget.id);
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 240, 174),
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 0,
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
      child: getProductController.getIsLoading 
        ? Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
        : getProductController.getErrorProduct == null 
          ? SingleChildScrollView(
              child: Column(
                spacing: 20,
                children: <Widget>[
                  Text(
                    getProductController.getProduct!.productName,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Container(
                      height: size.height * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                         ),
                      ),
                      child: Icon(Icons.image, size: size.height * 0.2, color: Colors.white),
                    ),
                  ),  
                  CardProductDetail(
                    description: getProductController.getProduct!.description, 
                    unitaryPrice: getProductController.getProduct!.unitaryPrice.toStringAsFixed(2), 
                    stock: getProductController.getProduct!.stock.toString()
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const Text(
                          "Select Quantity",
                          style:  TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                        ),
                        SelectQuantity(
                          stockQuantity: getProductController.getProduct!.stock, 
                          onChanged: (value) => selectedQuantity = value,
                        ),
                      ],
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Button(buttonText: "Add to Cart", function: _addProduct),
                  ),
                ],
              ),
            )
          : Center(
              child: Text(
                getProductController.getErrorProduct!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  Future<bool> _checkAuth() async {
    _auth = await _verifyTokens.checkAccessToken(token);

    return _auth == MapAuthEnum.mapper(AuthEnum.authenticated) ? true : false;
  }
  
  Future<void> _addProduct() async {
    final bool check = await _checkAuth();

    if (!check) {
      _goToLogin();
      return;
    }

    if (selectedQuantity == 0 || selectedQuantity == getProductController.getProduct!.stock) return;

    AddProductCartModel addProductModel = AddProductCartModel(
      productId: widget.id, 
      quantity: selectedQuantity,
    );
    final tokenType = TokenType.accessToken;
    final accessToken = await _authServices.getToken(TokenTypeEnum.mapper(tokenType));

    await addProductCartController.addProductCart(addProductModel, accessToken!);

    if (addProductCartController.getErrorAddProduct == null) {
      showMessage();
    }
  }
  
  void showMessage() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Product added to the cart!")));
  }
  
  _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginPage();
        },
      ),
    );
  }
}