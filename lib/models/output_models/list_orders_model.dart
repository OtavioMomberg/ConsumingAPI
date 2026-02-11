import 'dart:convert';

class ListOrdersModel {
  List<Map<String, dynamic>> orders;

  ListOrdersModel({required this.orders});

  factory ListOrdersModel.fromMap(List<dynamic> list) {
    return ListOrdersModel(
      orders: list.map((e) => Map<String, dynamic>.from(e)).toList(),
    );
  }

  factory ListOrdersModel.fromJson(String source) => ListOrdersModel.fromMap(jsonDecode(source));
}