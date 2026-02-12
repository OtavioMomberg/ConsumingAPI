import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CarousselItens extends StatelessWidget {
  final List<Map<String, dynamic>> itens;
  final void Function(int) productPage;
  const CarousselItens({required this.itens, required this.productPage, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 5),
      child: CarouselView.weighted(
        flexWeights: [1],
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: (value) => productPage(value),
        children: <Widget>[
          ...List<Widget>.generate(itens.length, (int index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(
                    "${itens[index]["product_name"]}",
                    maxLines: 1,
                    minFontSize: 10,
                    maxFontSize: 16,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  AutoSizeText(
                    "${itens[index]["unitary_price"]}",
                    maxLines: 1,
                    minFontSize: 10,
                    maxFontSize: 16,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}