import 'package:flutter/material.dart';

enum TopTabType { pachinko, gacha, hamari, settings }

class TopTabBar extends StatelessWidget {
  final TopTabType current;
  final void Function(int)? onTabChange; // ←追加！

  const TopTabBar({super.key, required this.current, this.onTabChange}); // ←追加！

  @override
  Widget build(BuildContext context) {
    Color selectedColor = Colors.deepPurple;
    Color unselectedColor = Colors.black.withOpacity(0.6);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextButton(
            onPressed:
                current == TopTabType.pachinko
                    ? null
                    : () => onTabChange?.call(0),
            child: Text(
              "パチンコ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    current == TopTabType.pachinko
                        ? selectedColor
                        : unselectedColor,
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed:
                current == TopTabType.gacha ? null : () => onTabChange?.call(1),
            child: Text(
              "ガチャ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    current == TopTabType.gacha
                        ? selectedColor
                        : unselectedColor,
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed:
                current == TopTabType.hamari
                    ? null
                    : () => onTabChange?.call(2),
            child: Text(
              "はまり",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    current == TopTabType.hamari
                        ? selectedColor
                        : unselectedColor,
              ),
            ),
          ),
        ),
        Expanded(
          child: IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "設定",
            onPressed: () => onTabChange?.call(3),
            color:
                current == TopTabType.settings
                    ? selectedColor
                    : unselectedColor,
          ),
        ),
      ],
    );
  }
}
