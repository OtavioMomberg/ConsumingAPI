import 'package:flutter/material.dart';

class CardDetailOrder extends StatelessWidget {
  final String productName;
  final String quantity;
  final String totalPrice;
  final String unitaryPrice;
  const CardDetailOrder({
    required this.productName,
    required this.quantity,
    required this.totalPrice,
    required this.unitaryPrice,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Product Name: $productName", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("Quantity: $quantity", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("Total Price: R\$ $totalPrice", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("Unitary Price: R\$ $unitaryPrice", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Divider(color: Colors.white.withValues(alpha: 0.5)),
        ],
      ),
    );
  }
}