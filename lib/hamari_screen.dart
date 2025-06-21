import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'setting_screen.dart';
import 'gachamode_screen.dart';
import 'pachinko_form.dart';

enum TopTabType { pachinko, gacha, hamari }

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
        // パチンコ
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
        // ガチャ
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
        // はまり
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
        // 設定
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

// パチンコモードのDigitInputFieldをそのまま流用
class DigitInputField extends StatelessWidget {
  final String label;
  final List<int> digits;
  final int length;
  final ValueChanged<List<int>> onChanged;
  final bool enabled;

  const DigitInputField({
    super.key,
    required this.label,
    required this.digits,
    required this.length,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    String valueStr =
        int.parse(digits.map((d) => d.toString()).join()).toString();
    return GestureDetector(
      onTap:
          enabled
              ? () async {
                List<int> temp = List<int>.from(digits);
                List<int>? picked = await showModalBottomSheet<List<int>>(
                  context: context,
                  builder: (ctx) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          "$labelを選択",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 170,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(length, (i) {
                              return SizedBox(
                                width: 46,
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: temp[i],
                                  ),
                                  itemExtent: 34,
                                  onSelectedItemChanged: (val) => temp[i] = val,
                                  children: List.generate(
                                    10,
                                    (j) => Center(
                                      child: Text(
                                        "$j",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          child: const Text("決定"),
                          onPressed: () => Navigator.pop(ctx, temp),
                        ),
                        const SizedBox(height: 14),
                      ],
                    );
                  },
                );
                if (picked != null) onChanged(picked);
              }
              : null,
      child: AbsorbPointer(
        child: TextField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            hintText: '-' * length,
            enabled: enabled,
          ),
          controller: TextEditingController(text: valueStr),
          style: TextStyle(color: enabled ? Colors.black : Colors.grey),
        ),
      ),
    );
  }
}

class HamariScreen extends StatefulWidget {
  const HamariScreen({Key? key}) : super(key: key);

  @override
  State<HamariScreen> createState() => _HamariScreenState();
}

class _HamariScreenState extends State<HamariScreen> {
  List<int> _bunboDigits = [0, 3, 1, 9]; // 0319→319
  List<int> _countDigits = [1, 0, 0, 0]; // 1000

  String? _resultText;
  String? _exampleText;

  double? _percentAtaru;

  int _digitsToInt(List<int> d) => d.fold(0, (a, b) => a * 10 + b);

  final List<String> _exampleList = [
    'これは宝くじ1等に当たるより低い確率です。',
    '雷に打たれるよりも低い確率です。',
    // ここに増やせます
  ];

  void _calcResult() {
    setState(() {
      _resultText = null;
      _exampleText = null;
      _percentAtaru = null;
    });

    int bunbo = _digitsToInt(_bunboDigits);
    int count = _digitsToInt(_countDigits);

    if (bunbo < 1 || count < 1) {
      setState(() {
        _resultText = "各項目は1以上の整数で入力してください。";
      });
      return;
    }

    double p = 1 / bunbo;
    // n回以上ハマる確率のみ
    double prob = pow(1 - p, count).toDouble();
    double percent = prob * 100;
    double percentAtaru = (1 - prob) * 100;
    double oneIn = 1 / prob;
    _resultText =
        "$count回転ハマる確率は${percent.toStringAsFixed(2)}%（1/${oneIn.toStringAsFixed(0)}）";

    _exampleText = _exampleList[Random().nextInt(_exampleList.length)];
    _percentAtaru = percentAtaru;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopTabBar(current: TopTabType.hamari), // ← モードに応じて切り替え
              const SizedBox(height: 10),
              DigitInputField(
                label: "大当たり確率（1/）",
                digits: _bunboDigits,
                length: 4,
                onChanged: (val) => setState(() => _bunboDigits = val),
              ),
              const SizedBox(height: 18),
              DigitInputField(
                label: "ハマリ回数",
                digits: _countDigits,
                length: 4,
                onChanged: (val) => setState(() => _countDigits = val),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calcResult,
                  child: const Text('計算'),
                ),
              ),
              const SizedBox(height: 24),
              if (_resultText != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _resultText!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (_percentAtaru != null)
                      Text("※当たる確率は${_percentAtaru!.toStringAsFixed(2)}%"),
                    const SizedBox(height: 8),
                    Text(_exampleText ?? ''),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
