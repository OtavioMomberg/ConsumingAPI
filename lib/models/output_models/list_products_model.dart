import 'dart:convert';

class ListProductsModel {
  List<Map<String, dynamic>> products;

  ListProductsModel({required this.products});

  factory ListProductsModel.fromMap(List<dynamic> list) {
    return ListProductsModel(
      products: list.map((e) => Map<String, dynamic>.from(e)).toList(),
    );
  }

  factory ListProductsModel.fromJson(String source) => ListProductsModel.fromMap(jsonDecode(source));
}