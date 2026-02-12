import 'dart:convert';

class ListSearchedProducts {
  List<Map<String, dynamic>> products;

  ListSearchedProducts({required this.products});

  factory ListSearchedProducts.fromList(List<dynamic> list) {
    return ListSearchedProducts(products: list.map((e) => Map<String, dynamic>.from(e)).toList());
  }

  factory ListSearchedProducts.fromJson(String source) => ListSearchedProducts.fromList(jsonDecode(source));
}