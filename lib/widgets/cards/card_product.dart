import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CardProduct extends StatelessWidget {
  final String title;
  final String subtitle;
  final int index;
  final void Function(int) function;
  const CardProduct({
    required this.title,
    required this.subtitle,
    required this.index,
    required this.function,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(index),
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(top:5, bottom: 5),
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 2,
              children: <Widget>[
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Icon(Icons.image, color: Colors.white),
                ),
                AutoSizeText(
                  title, 
                  maxLines: 1,
                  minFontSize: 10,
                  maxFontSize: 16,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                AutoSizeText(
                  "R\$ $subtitle", 
                  maxLines: 1,
                  minFontSize: 10,
                  maxFontSize: 16,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
        ),
    );
  }
}