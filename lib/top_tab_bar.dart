import 'package:flutter/material.dart';
import 'pachinko_form.dart';
import 'setting_screen.dart';
import 'gachamode_screen.dart';
import 'hamari_screen.dart';

enum TopTabType { pachinko, gacha, hamari, settings }

class TopTabBar extends StatelessWidget {
  final TopTabType current;
  const TopTabBar({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    Color selectedColor = Colors.deepPurple;
    Color unselectedColor = Colors.black.withOpacity(0.6);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed:
              current == TopTabType.pachinko
                  ? null
                  : () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const PachinkoForm()),
                    );
                  },
          child: Text(
            "パチンコモード",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  current == TopTabType.pachinko
                      ? selectedColor
                      : unselectedColor,
            ),
          ),
        ),
        TextButton(
          onPressed:
              current == TopTabType.gacha
                  ? null
                  : () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const GachaModeScreen(),
                      ),
                    );
                  },
          child: Text(
            "ガチャモード",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  current == TopTabType.gacha ? selectedColor : unselectedColor,
            ),
          ),
        ),
        TextButton(
          onPressed:
              current == TopTabType.hamari
                  ? null
                  : () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HamariScreen()),
                    );
                  },
          child: Text(
            "はまりモード",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  current == TopTabType.hamari
                      ? selectedColor
                      : unselectedColor,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: "設定",
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingScreen()));
          },
        ),
      ],
    );
  }
}
