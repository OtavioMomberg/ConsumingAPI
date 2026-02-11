import 'package:flutter/material.dart';
import 'package:tomate_shop/widgets/bottom_tab.dart';

class BottomBar extends StatelessWidget {
  final Map<String, IconData> iconButtons;
  final List<bool> controllButtons;
  final void Function(int) switchTab;

  const BottomBar({
    required this.iconButtons,
    required this.controllButtons,
    required this.switchTab,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ...List.generate(iconButtons.length, (index) {
              final data = iconButtons.entries.elementAt(index);
              return BottomTab(
                icon: data.value,
                tabName: data.key,
                index: index,
                color: controllButtons[index],
                switchTab: switchTab,
              );
            }),
          ],
        ),
      );
  }
}
