import 'package:flutter/material.dart';

class CardCartProduct extends StatelessWidget {
  final int index;
  final String title;
  final double totalPrice;
  final int quantity;
  final int productId;
  final void Function(int) openProductPage;
  final Future<void> Function(int, int) updateProduct;
  final Future<void> Function(int, int) removeProduct;

  const CardCartProduct({
    required this.index,
    required this.title,
    required this.totalPrice,
    required this.quantity,
    required this.productId,
    required this.openProductPage,
    required this.updateProduct,
    required this.removeProduct,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openProductPage(index),
      child: Container(
        height: 150,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          color: Colors.white.withValues(alpha: 0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await updateProduct(productId, index);
                      },
                      icon: Icon(Icons.edit, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () async {
                        await removeProduct(productId, index);
                      },
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              "Total Price: R\$ $totalPrice",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Quantity: $quantity",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
