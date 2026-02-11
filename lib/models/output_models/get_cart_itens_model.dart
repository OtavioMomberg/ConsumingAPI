import 'dart:convert';

class GetCartItensModel {
  Map<String, dynamic> cartDetails;

  GetCartItensModel({required this.cartDetails});

  factory GetCartItensModel.fromMap(Map<String, dynamic> map) => GetCartItensModel(cartDetails: map);

  factory GetCartItensModel.fromJson(String source) => GetCartItensModel.fromMap(jsonDecode(source));
}