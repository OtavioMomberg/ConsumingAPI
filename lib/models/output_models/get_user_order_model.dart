import 'dart:convert';

class GetUserOrderModel {
  Map<String, dynamic> order;

  GetUserOrderModel({required this.order});

  factory GetUserOrderModel.fromMap(Map <String, dynamic> map) => GetUserOrderModel(order: map);

  factory GetUserOrderModel.fromJson(String source) => GetUserOrderModel.fromMap(jsonDecode(source));
}