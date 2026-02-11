import 'package:flutter/material.dart';

class CardOrders extends StatelessWidget {
  final String name;
  final String finalPrice;
  final String time;
  final String status;
  final int historyId;
  final void Function(int?) orderPage;
  final Future<void> Function(int?) cancelOrder; 
  const CardOrders({
    required this.name,
    required this.finalPrice,
    required this.time,
    required this.status,
    required this.historyId,
    required this.orderPage,
    required this.cancelOrder,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => orderPage(historyId),
      child: Container(
        height: 150,
        margin: const EdgeInsets.only(top:5, bottom: 5),
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => cancelOrder(historyId), icon: Icon(Icons.cancel, color: Colors.white)),
              ],
            ),
            Text("Final Price: R\$ $finalPrice", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Time: $time", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Status: $status", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}