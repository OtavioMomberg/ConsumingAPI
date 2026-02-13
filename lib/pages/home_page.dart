import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tomate_shop/controllers/list_products_controller.dart';
import 'package:tomate_shop/controllers/list_searched_products_controller.dart';
import 'package:tomate_shop/repositories/implementarions/list_products_implementation_http.dart';
import 'package:tomate_shop/pages/product_page.dart';
import 'package:tomate_shop/repositories/implementarions/list_searched_products_implementation_http.dart';
import 'package:tomate_shop/widgets/cards/card_product.dart';
import 'package:tomate_shop/widgets/caroussel_itens.dart';
import 'package:tomate_shop/widgets/input_fields/search_input.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final ListProductsController _listProductsController;
  late final ListSearchedProductsController _listSearchedProductsController;
  final _searchController = TextEditingController();
  late String tokenType;
  bool getProductControllerInitialized = false;
  List<Map<String, dynamic>> carousselItens = [];
  List<Map<String, dynamic>> gridItens = [];

  @override
  void initState() {
    super.initState();

    _listProductsController = ListProductsController(
      ListProductsImplementationHttp(client: Client()),
    );

    _listSearchedProductsController = ListSearchedProductsController(
      ListSearchedProductsImplementationHttp(client: Client()),
    );
    
    loadProducts();
  }

  void loadProducts() async {
    carousselItens.clear();
    gridItens.clear();
    
    await _listProductsController.onListProducts();
      
    if (_listProductsController.getListProductsModel?.products == null) return;

    final products = _listProductsController.getListProductsModel!.products;
    final limit = products.length < 10 ? products.length : 10;

    for (int i=0; i<limit; i++) {
      carousselItens.add(products[i]);
    }
      
    for (int i=limit; i<products.length; i++) {
      gridItens.add(products[i]);
    }

    await _listSearchedProductsController.onListProducts("");
      
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
      padding: const EdgeInsets.only(top: 20, bottom: 95),
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
      child: _listProductsController.getLoadProducts 
        ? Center(child: CircularProgressIndicator(color: Colors.white))
        : _listProductsController.getErrorLoadProducts == null 
          ? CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    child: SearchInput(controller: _searchController, function: _searchItem),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: CarousselItens(itens: carousselItens, productPage: _productPage),
                  ),
                ),
                if (_listSearchedProductsController.getErrorLoadProducts != null)...{
                  SliverGrid.builder(
                    itemCount: gridItens.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: index % 2 == 0 
                          ? const EdgeInsets.only(left: 10, right: 5) 
                          : const EdgeInsets.only(left: 5, right: 10),
                        child: CardProduct(
                          title: gridItens[index]['product_name'] ?? "", 
                          subtitle: gridItens[index]['unitary_price'].toString(), 
                          index: index+10,
                          function: _productPage,
                        ),
                      );
                    },
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.9),
                  ),
                } else...{
                  SliverList.builder(
                    itemCount: _listSearchedProductsController.getListSearchedProducts!.products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: CardProduct(
                          title: _listSearchedProductsController.getListSearchedProducts!.products[index]["product_name"],  
                          subtitle: _listSearchedProductsController.getListSearchedProducts!.products[index]["unitary_price"].toString(),
                          index: index+10,
                          function: _productPage,
                        ),
                      );
                    }
                  ),
                },
              ],
            ) 
          : Center(
              child: Text(
                _listProductsController.getErrorLoadProducts!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  void _productPage(int index) {
    if (_listProductsController.getListProductsModel?.products[index]['id'] == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return ProductPage(
          id: _listProductsController.getListProductsModel?.products[index]['id'],
        );
      }),
    );
  }

  Future<void> _searchItem(String item) async {
    await _listSearchedProductsController.onListProducts(item);
    
    if (_listSearchedProductsController.getErrorLoadProducts != null && item.isNotEmpty) {
      await _showMessage(_listSearchedProductsController.getErrorLoadProducts!);
    }

    setState(() {});
  }

  Future<void> _showMessage(String text) async {
    await showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: const Text("Error", style: TextStyle(color: Color.fromARGB(255, 254, 160, 109))),
        content: Text(text, style: const TextStyle(color: Color.fromARGB(255, 254, 160, 109))),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}