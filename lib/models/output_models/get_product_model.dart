import 'dart:convert';

class GetProductModel {
  String productName;
  String description;
  double unitaryPrice;
  int stock;

  GetProductModel({
    required this.productName,
    required this.description,
    required this.unitaryPrice,
    required this.stock,
  });

  factory GetProductModel.fromMap(Map<String, dynamic> map) {
    return GetProductModel(
      productName: map['product_name'], 
      description: map['description'], 
      unitaryPrice: map['unitary_price'], 
      stock: map['stock'],
    );
  }

  factory GetProductModel.fromJson(String source) => GetProductModel.fromMap(jsonDecode(source));
}