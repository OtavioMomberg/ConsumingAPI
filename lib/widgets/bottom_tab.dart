import 'package:flutter/material.dart';

class BottomTab extends StatelessWidget {
  final IconData icon;
  final String tabName;
  final int index;
  final bool color;
  final void Function(int) switchTab;

  const BottomTab({
    required this.icon,
    required this.tabName,
    required this.index,
    required this.color,
    required this.switchTab,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => switchTab(index),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.1),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: !color ? 1.0: 1.4,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: Opacity(
                  opacity: !color ? 0.8 : 1.0, 
                  child: Icon(
                    icon,
                    color: !color 
                      ? const Color.fromARGB(255, 255, 255, 255) 
                      : const Color.fromARGB(255, 253, 149, 93).withValues(alpha: 0.8),
                  ),
                ),   
              ),
              Text(
                tabName, 
                style: TextStyle(
                  color: !color 
                    ? const Color.fromARGB(255, 255, 255, 255) 
                    : const Color.fromARGB(255, 253, 149, 93)
                ),
              ),
            ],
          ),
        
      ),
    );
  }
}
