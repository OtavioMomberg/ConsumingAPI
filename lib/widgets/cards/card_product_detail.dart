import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CardProductDetail extends StatelessWidget {
  final String description;
  final String unitaryPrice;
  final String stock;
  const CardProductDetail({
    required this.description,
    required this.unitaryPrice,
    required this.stock,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Container(
        height: 170,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AutoSizeText(
                "Product Details:",
                maxLines: 1,
                minFontSize: 18,
                maxFontSize: 30,
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  fontSize: 25
                ),
              ),
              const SizedBox(height: 10),
              AutoSizeText(
                description,
                maxLines: 1,
                minFontSize: 12,
                maxFontSize: 18,
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),                          
              AutoSizeText(
                "R\$ $unitaryPrice",
                maxLines: 1,
                minFontSize: 12,
                maxFontSize: 18,
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
              AutoSizeText(
                "$stock avaliable",
                maxLines: 1,
                minFontSize: 12,
                maxFontSize: 18,
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ), 
            ],
          ),
        ),
      ),
    );
  }
}