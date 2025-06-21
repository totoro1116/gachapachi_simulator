import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'setting_screen.dart';
import 'gachamode_screen.dart';
import 'hamari_screen.dart';
import 'package:gacha_simulator/models/saved_data.dart';

//import 'padhinko_detail_settings.dart';

enum LtMode { none, direct, challenge, upgrade }

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

class DigitInputField extends StatelessWidget {
  final String label;
  final List<int> digits;
  final int length;
  final ValueChanged<List<int>> onChanged;
  final bool enabled;
  final bool isAtari;

  const DigitInputField({
    super.key,
    required this.label,
    required this.digits,
    required this.length,
    required this.onChanged,
    this.enabled = true,
    this.isAtari = false,
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
                              List<int> values;
                              // --- 百の位（i==0, 3桁の場合）だけ0,1のみ ---
                              if (length == 3 && i == 0) {
                                if (isAtari) {
                                  values = List.generate(10, (j) => j); // 0〜9
                                } else {
                                  values = [0, 1]; // 0,1だけ
                                }
                              } else {
                                values = List.generate(10, (j) => j);
                              }
                              return SizedBox(
                                width: 46,
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: temp[i],
                                  ),
                                  itemExtent: 34,
                                  onSelectedItemChanged:
                                      (val) => temp[i] = values[val],
                                  children:
                                      values
                                          .map(
                                            (j) => Center(
                                              child: Text(
                                                "$j",
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
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

class PachinkoForm extends StatefulWidget {
  const PachinkoForm({super.key});
  @override
  State<PachinkoForm> createState() => _PachinkoFormState();
}

class _PachinkoFormState extends State<PachinkoForm> {
  List<int> _atariDigits = [1, 9, 9];
  List<int> _totsunyuDigits = [0, 5, 0];
  List<int> _keizokuDigits = [5, 0];

  List<List<int>> _dedamaDigitsList = [
    [1, 5, 0, 0],
  ];
  List<List<int>> _addDedamaDigitsList = [
    [0, 0, 0, 0],
  ];
  List<List<int>> _loopRateDigitsList = [
    [0, 0],
  ];
  List<List<int>> _dedamaRateDigitsList = [
    [1, 0, 0],
  ];
  // 100%

  LtMode _ltMode = LtMode.none;
  List<int> _ltTotsunyuDigits = [0, 5, 0];
  List<int> _ltKeizokuDigits = [5, 0];
  List<int> _ltChallengeDigits = [0, 5, 0];
  List<int> _ltBreakDigits = [0, 5, 0];
  List<int> _ltUpgradeRateDigits = [0, 5, 0];

  List<List<int>> _ltDedamaDigitsList = [
    [1, 5, 0, 0],
  ];
  List<List<int>> _ltAddDedamaDigitsList = [
    [0, 0, 0, 0],
  ];
  List<List<int>> _ltLoopRateDigitsList = [
    [0, 0],
  ];

  List<List<int>> _ltDedamaRateDigitsList = [
    [1, 0, 0],
  ];

  String _result = "";

  int _digitsToInt(List<int> d) => d.fold(0, (a, b) => a * 10 + b);

  void _resetAllFields() {
    setState(() {
      // --- 各モードの初期値に戻す ---
      _atariDigits = [1, 9, 9];
      _totsunyuDigits = [0, 5, 0];
      _keizokuDigits = [5, 0];

      _dedamaDigitsList = [
        [1, 5, 0, 0],
      ];
      _addDedamaDigitsList = [
        [0, 0, 0, 0],
      ];
      _loopRateDigitsList = [
        [0, 0],
      ];
      _dedamaRateDigitsList = [
        [1, 0, 0],
      ];

      _ltMode = LtMode.none;

      _ltTotsunyuDigits = [0, 5, 0];
      _ltKeizokuDigits = [5, 0];
      _ltChallengeDigits = [0, 5, 0];
      _ltBreakDigits = [0, 5, 0];
      _ltUpgradeRateDigits = [0, 5, 0];

      _ltDedamaDigitsList = [
        [1, 5, 0, 0], // ← LT中出玉数（デフォ：1500）
      ];
      _ltAddDedamaDigitsList = [
        [0, 0, 0, 0], // ← LT中上乗せ出玉数（デフォ：0）
      ];
      _ltLoopRateDigitsList = [
        [0, 0], // ← LT中ループ率（デフォ：0, 2桁のみ）
      ];
      _ltDedamaRateDigitsList = [
        [1, 0, 0], // ← LT中割合（デフォ：100）
      ];

      _result = "";
    });
  }

  void _saveData(String title, DateTime time, String resultText) {
    // --- 通常の出玉振り分け表示 ---
    String dedamaText = "";
    for (int i = 0; i < _dedamaDigitsList.length; i++) {
      final base = _digitsToInt(_dedamaDigitsList[i]);
      final add = _addDedamaDigitsList[i];
      final loop = _loopRateDigitsList[i];
      final rate = _digitsToInt(_dedamaRateDigitsList[i]);

      final hasAlpha = add.any((d) => d > 0) && _digitsToInt(loop) > 0;
      dedamaText += hasAlpha ? "${base}発＋α ${rate}%\n" : "${base}発 ${rate}%\n";
    }

    // --- LT中出玉振り分け（直行・チャレンジ・昇格型のみ） ---
    String ltDedamaText = "";
    if (_ltMode != LtMode.none) {
      for (int i = 0; i < _ltDedamaDigitsList.length; i++) {
        final base = _digitsToInt(_ltDedamaDigitsList[i]);
        final add = _ltAddDedamaDigitsList[i];
        final loop = _ltLoopRateDigitsList[i];
        final rate = _digitsToInt(_ltDedamaRateDigitsList[i]);

        final hasAlpha = add.any((d) => d > 0) && _digitsToInt(loop) > 0;
        ltDedamaText +=
            hasAlpha ? "${base}発＋α ${rate}%\n" : "${base}発 ${rate}%\n";
      }
    }

    // --- 日本語化されたLTモード名 ---
    // --- 日本語LTモード名 ---
    String ltModeName =
        {
          LtMode.none: "なし（通常確変）",
          LtMode.direct: "直行型",
          LtMode.challenge: "チャレンジ型",
          LtMode.upgrade: "昇格型",
        }[_ltMode]!;

    // --- モード別の突入・継続表示 ---
    String modeDetails = "";

    if (_ltMode == LtMode.none || _ltMode == LtMode.upgrade) {
      modeDetails = """
確変突入率: ${_digitsToInt(_totsunyuDigits)}%
確変継続率: ${_digitsToInt(_keizokuDigits)}%
""";
    } else if (_ltMode == LtMode.direct) {
      modeDetails = """
LT突入率: ${_digitsToInt(_ltTotsunyuDigits)}%
LT継続率: ${_digitsToInt(_ltKeizokuDigits)}%
""";
    } else if (_ltMode == LtMode.challenge) {
      modeDetails = """
LTチャレンジ率: ${_digitsToInt(_ltChallengeDigits)}%
チャレンジ突破率: ${_digitsToInt(_ltBreakDigits)}%
LT継続率: ${_digitsToInt(_ltKeizokuDigits)}%
""";
    }

    // --- specText 全体構成 ---
    String specText = """
【入力スペック】
大当たり確率: 1/${_digitsToInt(_atariDigits)}
$modeDetails
""";

    if (!(_ltMode == LtMode.direct || _ltMode == LtMode.challenge)) {
      specText += "出玉振り分け:\n$dedamaText";
    }

    specText += "LTモード: $ltModeName\n";

    if (_ltMode != LtMode.none) {
      specText += "LT中出玉振り分け:\n$ltDedamaText";
    }

    // --- 保存 ---
    savedPachiList.add(
      SavedPachiData(
        title: title,
        savedAt: time,
        resultText: resultText,
        specText: specText,
      ),
    );
    saveSavedPachiList();
  }

  void _confirmReset() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("リセット確認"),
            content: const Text("すべての入力値を初期化してよろしいですか？"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("キャンセル"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _resetAllFields();
                },
                child: const Text(
                  "リセット",
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
    );
  }

  void _addLtDedama() {
    setState(() {
      _ltDedamaDigitsList.add([0, 0, 0, 0]);
      _ltAddDedamaDigitsList.add([0, 0, 0, 0]);
      _ltLoopRateDigitsList.add([0, 0]);
      _ltDedamaRateDigitsList.add([0, 0, 0]);
    });
  }

  void _removeLtDedama(int i) {
    setState(() {
      _ltDedamaDigitsList.removeAt(i);
      _ltAddDedamaDigitsList.removeAt(i);
      _ltLoopRateDigitsList.removeAt(i);
      _ltDedamaRateDigitsList.removeAt(i);
    });
  }

  void _calculate() {
    try {
      // --- 確変突入率バリデーション ---
      if (_digitsToInt(_totsunyuDigits) > 100) {
        setState(() {
          _result = "警告：確変突入率は100%までです。";
        });
        return;
      }
      // --- LT突入率 ---
      if (_digitsToInt(_ltTotsunyuDigits) > 100) {
        setState(() {
          _result = "警告：LT突入率は100%までです。";
        });
        return;
      }

      // --- LTチャレンジ率 ---
      if (_digitsToInt(_ltChallengeDigits) > 100) {
        setState(() {
          _result = "警告：LTチャレンジ率は100%までです。";
        });
        return;
      }

      // --- LT突破率 ---
      if (_digitsToInt(_ltBreakDigits) > 100) {
        setState(() {
          _result = "警告：LT突破率は100%までです。";
        });
        return;
      }

      // --- LT振り分け率 ---
      if (_digitsToInt(_ltUpgradeRateDigits) > 100) {
        setState(() {
          _result = "警告：LT振り分け率は100%までです。";
        });
        return;
      }
      // ===== 上乗せループ率チェック（1〜99のみOK、それ以外は警告） =====
      for (int i = 0; i < _loopRateDigitsList.length; i++) {
        final loop = _digitsToInt(_loopRateDigitsList[i]);
        if (loop != 0 && (loop < 1 || loop > 99)) {
          setState(() {
            _result = "警告：上乗せループ率は1～99%の間だけ設定できます。";
          });
          return;
        }
      }
      for (int i = 0; i < _ltLoopRateDigitsList.length; i++) {
        final loop = _digitsToInt(_ltLoopRateDigitsList[i]);
        if (loop != 0 && (loop < 1 || loop > 99)) {
          setState(() {
            _result = "警告：LT中上乗せループ率は1～99%の間だけ設定できます。";
          });
          return;
        }
      }

      // ===== 出玉振り分け割合チェック（合計100のみOK） =====
      int sum = 0;
      for (int i = 0; i < _dedamaRateDigitsList.length; i++) {
        sum += _digitsToInt(_dedamaRateDigitsList[i]);
      }
      if (sum != 100) {
        setState(() {
          _result = "警告：出玉振り分け割合（%）の合計は100%にしてください。";
        });
        return;
      }

      int ltSum = 0;
      for (int i = 0; i < _ltDedamaRateDigitsList.length; i++) {
        ltSum += _digitsToInt(_ltDedamaRateDigitsList[i]);
      }
      if ((_ltMode == LtMode.direct ||
              _ltMode == LtMode.challenge ||
              _ltMode == LtMode.upgrade) &&
          ltSum != 100) {
        setState(() {
          _result = "警告：LT中出玉振り分け割合（%）の合計は100%にしてください。";
        });
        return;
      }
      String res = "";
      final atari = _digitsToInt(_atariDigits).toDouble();
      final totsunyu = _digitsToInt(_totsunyuDigits).toDouble();
      final keizoku = _digitsToInt(_keizokuDigits).toDouble();

      // 通常出玉振り分け（上乗せ対応）
      double dedamaSum = 0;
      for (int i = 0; i < _dedamaDigitsList.length; i++) {
        final d = _digitsToInt(_dedamaDigitsList[i]).toDouble(); // 出玉数
        final add =
            _addDedamaDigitsList.length > i
                ? _digitsToInt(_addDedamaDigitsList[i]).toDouble()
                : 0.0; // 上乗せ出玉数
        final loop =
            _loopRateDigitsList.length > i
                ? _digitsToInt(_loopRateDigitsList[i]).toDouble()
                : 0.0; // ループ率
        final r = _digitsToInt(_dedamaRateDigitsList[i]).toDouble(); // 割合

        double avgAdd = 0;
        if (add > 0 && loop > 0) {
          double loopP = loop / 100.0;
          avgAdd = add * (loopP / (1 - loopP));
        }
        final total = d + avgAdd;
        dedamaSum += total * (r / 100);
      }

      // LT中出玉振り分け（上乗せ対応）
      double ltDedamaSum = 0;
      for (int i = 0; i < _ltDedamaDigitsList.length; i++) {
        final d = _digitsToInt(_ltDedamaDigitsList[i]).toDouble();
        final add =
            _ltAddDedamaDigitsList.length > i
                ? _digitsToInt(_ltAddDedamaDigitsList[i]).toDouble()
                : 0.0;
        final loop =
            _ltLoopRateDigitsList.length > i
                ? _digitsToInt(_ltLoopRateDigitsList[i]).toDouble()
                : 0.0;
        final r = _digitsToInt(_ltDedamaRateDigitsList[i]).toDouble();

        double avgAdd = 0;
        if (add > 0 && loop > 0) {
          double loopP = loop / 100.0;
          avgAdd = add * (loopP / (1 - loopP));
        }
        final total = d + avgAdd;
        ltDedamaSum += total * (r / 100);
      }

      if (_ltMode == LtMode.none) {
        final atari = _digitsToInt(_atariDigits).toDouble();
        final totsunyu = _digitsToInt(_totsunyuDigits).toDouble();
        final keizoku = _digitsToInt(_keizokuDigits).toDouble();

        double dedamaSum = 0;
        for (int i = 0; i < _dedamaDigitsList.length; i++) {
          final d = _digitsToInt(_dedamaDigitsList[i]).toDouble();
          final add =
              _addDedamaDigitsList.length > i
                  ? _digitsToInt(_addDedamaDigitsList[i]).toDouble()
                  : 0.0;
          final loop =
              _loopRateDigitsList.length > i
                  ? _digitsToInt(_loopRateDigitsList[i]).toDouble()
                  : 0.0;
          final r = _digitsToInt(_dedamaRateDigitsList[i]).toDouble();

          double avgAdd = 0;
          if (add > 0 && loop > 0) {
            double loopP = loop / 100.0;
            avgAdd = add * (loopP / (1 - loopP));
          }
          final total = d + avgAdd;
          dedamaSum += total * (r / 100);
        }
        double chain = 1 / (1 - (keizoku / 100));
        double jisshitsuAtari = atari / (totsunyu / 100);
        double rightUchi = dedamaSum * chain;

        res =
            "実質大当たり確率：1/${jisshitsuAtari.toStringAsFixed(0)}\n"
            "1回あたり平均出玉：${dedamaSum.toStringAsFixed(0)}発\n"
            "連チャン期待回数：約${chain.toStringAsFixed(2)}連\n"
            "右打ち期待出玉数：約${rightUchi.toStringAsFixed(0)}発";
      } else if (_ltMode == LtMode.direct) {
        final atari = _digitsToInt(_atariDigits).toDouble();
        final ltTotsunyu =
            _digitsToInt(_ltTotsunyuDigits).toDouble(); // LT突入率（%）
        final ltKeizoku = _digitsToInt(_ltKeizokuDigits).toDouble();

        double ltEnterProb = ltTotsunyu / 100;
        double jisshitsuLtDenominator = atari / ltEnterProb;
        String ltJisshitsuStr =
            (ltEnterProb > 0) ? '1/${jisshitsuLtDenominator.round()}' : "計算不能";

        double ltDedamaSum = 0;
        for (int i = 0; i < _ltDedamaDigitsList.length; i++) {
          final d = _digitsToInt(_ltDedamaDigitsList[i]).toDouble();
          final add =
              _ltAddDedamaDigitsList.length > i
                  ? _digitsToInt(_ltAddDedamaDigitsList[i]).toDouble()
                  : 0.0;
          final loop =
              _ltLoopRateDigitsList.length > i
                  ? _digitsToInt(_ltLoopRateDigitsList[i]).toDouble()
                  : 0.0;
          final r = _digitsToInt(_ltDedamaRateDigitsList[i]).toDouble();

          double avgAdd = 0;
          if (add > 0 && loop > 0) {
            double loopP = loop / 100.0;
            avgAdd = add * (loopP / (1 - loopP));
          }
          final total = d + avgAdd;
          ltDedamaSum += total * (r / 100);
        }
        double ltChain = 1 / (1 - (ltKeizoku / 100));
        double ltTotalDedama = ltDedamaSum * ltChain;

        res =
            "実質LT大当たり確率：$ltJisshitsuStr\n"
            "1回あたり平均出玉：${ltDedamaSum.toStringAsFixed(0)}発\n"
            "連チャン期待回数：約${ltChain.toStringAsFixed(2)}連\n"
            "LT突入時の期待出玉数：約${ltTotalDedama.toStringAsFixed(0)}発";
      } else if (_ltMode == LtMode.challenge) {
        final atari = _digitsToInt(_atariDigits).toDouble(); // 399
        final challenge = _digitsToInt(_ltChallengeDigits).toDouble(); // 75
        final breakProb = _digitsToInt(_ltBreakDigits).toDouble(); // 50
        final ltKeizoku = _digitsToInt(_ltKeizokuDigits).toDouble(); // 77

        double ltEnterProb = (challenge / 100) * (breakProb / 100);
        double jisshitsuLtDenominator = atari / ltEnterProb;
        String ltJisshitsuStr =
            (ltEnterProb > 0) ? '1/${jisshitsuLtDenominator.round()}' : "計算不能";

        // LT中出玉平均（上乗せロジック）
        double ltDedamaSum = 0;
        for (int i = 0; i < _ltDedamaDigitsList.length; i++) {
          final d = _digitsToInt(_ltDedamaDigitsList[i]).toDouble();
          final add =
              _ltAddDedamaDigitsList.length > i
                  ? _digitsToInt(_ltAddDedamaDigitsList[i]).toDouble()
                  : 0.0;
          final loop =
              _ltLoopRateDigitsList.length > i
                  ? _digitsToInt(_ltLoopRateDigitsList[i]).toDouble()
                  : 0.0;
          final r = _digitsToInt(_ltDedamaRateDigitsList[i]).toDouble();

          double avgAdd = 0;
          if (add > 0 && loop > 0) {
            double loopP = loop / 100.0;
            avgAdd = add * (loopP / (1 - loopP));
          }
          final total = d + avgAdd;
          ltDedamaSum += total * (r / 100);
        }
        double ltChain = 1 / (1 - (ltKeizoku / 100));
        double ltTotalDedama = ltDedamaSum * ltChain;

        res =
            "実質LT突入率：$ltJisshitsuStr\n"
            "1回あたり平均出玉：${ltDedamaSum.toStringAsFixed(0)}発\n"
            "連チャン期待回数：約${ltChain.toStringAsFixed(2)}連\n"
            "LT突入時の期待出玉数：約${ltTotalDedama.toStringAsFixed(0)}発";
      } else if (_ltMode == LtMode.upgrade) {
        // === 昇格型 計算ロジック ===
        final ltViwake = _digitsToInt(_ltUpgradeRateDigits).toDouble();
        final ltKeizoku = _digitsToInt(_ltKeizokuDigits).toDouble();

        // 連チャン期待回数（初当たり含む：一般的な意味）
        double chain = 1 / (1 - (keizoku / 100));
        // 継続回数のみ（初当たりを除外）
        double onlyContinuations = chain - 1;
        // LT振り分け率
        double pLT = ltViwake / 100;
        // 継続中に一度でもLTを引く確率（継続回数のみで計算）
        double ltEnterProb =
            1 - (pow(1 - pLT, onlyContinuations.toDouble()) as double);

        // 実質大当たり確率
        double jisshitsuAtari = atari / (totsunyu / 100); // 1/398
        // 実質LT突入率（通常時から“1/◯◯”で表示）
        double jisshitsuLtDenominator = jisshitsuAtari / ltEnterProb;
        String ltJisshitsuStr =
            (ltEnterProb > 0) ? '1/${jisshitsuLtDenominator.round()}' : "計算不能";

        // LT連チャン
        double joui_chain = 1 / (1 - (ltKeizoku / 100));
        // LT突入時の期待出玉（上乗せ対応）
        double ltDedamaSum = 0;
        for (int i = 0; i < _ltDedamaDigitsList.length; i++) {
          final d = _digitsToInt(_ltDedamaDigitsList[i]).toDouble();
          final add =
              _ltAddDedamaDigitsList.length > i
                  ? _digitsToInt(_ltAddDedamaDigitsList[i]).toDouble()
                  : 0.0;
          final loop =
              _ltLoopRateDigitsList.length > i
                  ? _digitsToInt(_ltLoopRateDigitsList[i]).toDouble()
                  : 0.0;
          final r = _digitsToInt(_ltDedamaRateDigitsList[i]).toDouble();

          double avgAdd = 0;
          if (add > 0 && loop > 0) {
            double loopP = loop / 100.0;
            avgAdd = add * (loopP / (1 - loopP));
          }
          final total = d + avgAdd;
          ltDedamaSum += total * (r / 100);
        }
        double ltTotalDedama = ltDedamaSum * joui_chain;

        // 総合右打ち期待出玉（従来式：分岐和）
        double normalEndProb = 1 - ltEnterProb;
        double normalTotalDedama =
            onlyContinuations * dedamaSum * normalEndProb;
        double ltTotalExpectedDedama = ltEnterProb * ltTotalDedama;
        double total_expected_dedama =
            normalTotalDedama + ltTotalExpectedDedama;

        res =
            "実質大当たり確率：1/${jisshitsuAtari.toStringAsFixed(0)}\n"
            "1回あたり平均出玉：${dedamaSum.toStringAsFixed(0)}発\n"
            "連チャン期待回数：約${chain.toStringAsFixed(2)}連\n"
            "実質LT突入率：$ltJisshitsuStr\n"
            "LT平均出玉：${ltDedamaSum.toStringAsFixed(0)}発\n"
            "LT連チャン期待回数：約${joui_chain.toStringAsFixed(2)}連\n"
            "LT突入時の期待出玉数：約${ltTotalDedama.toStringAsFixed(0)}発\n"
            "総合右打ち期待出玉：約${total_expected_dedama.toStringAsFixed(0)}発";
      }
      setState(() => _result = res);
    } catch (e) {
      setState(() => _result = "計算エラー: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDedamaDisabled =
        (_ltMode == LtMode.direct || _ltMode == LtMode.challenge);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopTabBar(current: TopTabType.pachinko),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: DigitInputField(
                        label: "通常時大当たり確率 (1/)",
                        digits: _atariDigits,
                        length: 3,
                        isAtari: true,
                        onChanged: (val) => setState(() => _atariDigits = val),
                      ),
                    ),

                    // IconButton(
                    //   icon: Icon(Icons.settings),
                    //   tooltip: "詳細設定",
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) => const PadhinkoDetailSettingsPage(),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_ltMode == LtMode.none || _ltMode == LtMode.upgrade)
                  Row(
                    children: [
                      Expanded(
                        child: DigitInputField(
                          label: "確変突入率（%）",
                          digits: _totsunyuDigits,
                          length: 3,
                          onChanged:
                              (val) => setState(() => _totsunyuDigits = val),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DigitInputField(
                          label: "確変継続率（%）",
                          digits: _keizokuDigits,
                          length: 2,
                          onChanged:
                              (val) => setState(() => _keizokuDigits = val),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                Opacity(
                  opacity: isDedamaDisabled ? 0.5 : 1,
                  child: IgnorePointer(
                    ignoring: isDedamaDisabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "出玉振り分け${isDedamaDisabled ? "（無効：LT型では使用しません）" : "（追加可）"}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...List.generate(_dedamaDigitsList.length, (i) {
                          return Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: DigitInputField(
                                  label: "出玉数",
                                  digits: _dedamaDigitsList[i],
                                  length: 4,
                                  onChanged:
                                      (val) => setState(
                                        () => _dedamaDigitsList[i] = val,
                                      ),
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ), // ←ここを4に変更（もしくはもっと詰めてもOK）
                              Flexible(
                                flex: 2,
                                child: DigitInputField(
                                  label: "上乗せ出玉数(任意)",
                                  digits: _addDedamaDigitsList[i],
                                  length: 4,
                                  onChanged:
                                      (val) => setState(
                                        () => _addDedamaDigitsList[i] = val,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                flex: 2,
                                child: DigitInputField(
                                  label: "ループ率(%)",
                                  digits: _loopRateDigitsList[i],
                                  length: 2,
                                  enabled: _addDedamaDigitsList[i].any(
                                    (d) => d != 0,
                                  ),
                                  onChanged:
                                      (val) => setState(
                                        () => _loopRateDigitsList[i] = val,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                flex: 1,
                                child: DigitInputField(
                                  label: "割合(%)",
                                  digits: _dedamaRateDigitsList[i],
                                  length: 3,
                                  onChanged:
                                      (val) => setState(
                                        () => _dedamaRateDigitsList[i] = val,
                                      ),
                                ),
                              ),
                              if (_dedamaDigitsList.length > 1 && i > 0)
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _dedamaDigitsList.removeAt(i);
                                      _addDedamaDigitsList.removeAt(i);
                                      _loopRateDigitsList.removeAt(i);
                                      _dedamaRateDigitsList.removeAt(i);
                                    });
                                  },
                                ),
                            ],
                          );
                        }),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _dedamaDigitsList.add([0, 0, 0, 0]);
                                _addDedamaDigitsList.add([0, 0, 0, 0]);
                                _loopRateDigitsList.add([0, 0]);
                                _dedamaRateDigitsList.add([0, 0, 0]);
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("追加"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "ラッキートリガーモード（LTモード）",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("なし（通常確変）", style: TextStyle(fontSize: 13)),
                    const Text("直行型", style: TextStyle(fontSize: 13)),
                    const Text("チャレンジ型", style: TextStyle(fontSize: 13)),
                    const Text("昇格型", style: TextStyle(fontSize: 13)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Radio<LtMode>(
                      value: LtMode.none,
                      groupValue: _ltMode,
                      onChanged: (v) => setState(() => _ltMode = v!),
                    ),
                    Radio<LtMode>(
                      value: LtMode.direct,
                      groupValue: _ltMode,
                      onChanged: (v) => setState(() => _ltMode = v!),
                    ),
                    Radio<LtMode>(
                      value: LtMode.challenge,
                      groupValue: _ltMode,
                      onChanged: (v) => setState(() => _ltMode = v!),
                    ),
                    Radio<LtMode>(
                      value: LtMode.upgrade,
                      groupValue: _ltMode,
                      onChanged: (v) => setState(() => _ltMode = v!),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_ltMode == LtMode.direct)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DigitInputField(
                        label: "LT突入率（%）",
                        digits: _ltTotsunyuDigits,
                        length: 3,
                        onChanged:
                            (val) => setState(() => _ltTotsunyuDigits = val),
                      ),
                      DigitInputField(
                        label: "LT継続率（%）",
                        digits: _ltKeizokuDigits,
                        length: 2,
                        onChanged:
                            (val) => setState(() => _ltKeizokuDigits = val),
                      ),
                      const Text(
                        "LT中出玉振り分け",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...List.generate(_ltDedamaDigitsList.length, (i) {
                        return Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: DigitInputField(
                                label: "出玉数",
                                digits: _ltDedamaDigitsList[i],
                                length: 4,
                                onChanged:
                                    (val) => setState(
                                      () => _ltDedamaDigitsList[i] = val,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              flex: 2,
                              child: DigitInputField(
                                label: "上乗せ出玉数（任意）",
                                digits: _ltAddDedamaDigitsList[i],
                                length: 4,
                                onChanged:
                                    (val) => setState(
                                      () => _ltAddDedamaDigitsList[i] = val,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              flex: 2,
                              child: DigitInputField(
                                label: "ループ率（%）",
                                digits: _ltLoopRateDigitsList[i],
                                length: 2,
                                enabled: _ltAddDedamaDigitsList[i].any(
                                  (d) => d != 0,
                                ),
                                onChanged:
                                    (val) => setState(
                                      () => _ltLoopRateDigitsList[i] = val,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              flex: 1,
                              child: DigitInputField(
                                label: "割合（%）",
                                digits: _ltDedamaRateDigitsList[i],
                                length: 3,
                                onChanged:
                                    (val) => setState(
                                      () => _ltDedamaRateDigitsList[i] = val,
                                    ),
                              ),
                            ),
                            if (_ltDedamaDigitsList.length > 1 && i > 0)
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () => _removeLtDedama(i),
                              ),
                          ],
                        );
                      }),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _addLtDedama,
                          icon: const Icon(Icons.add),
                          label: const Text("LT出玉追加"),
                        ),
                      ),
                    ],
                  ),
                if (_ltMode == LtMode.challenge)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DigitInputField(
                        label: "LTチャレンジ率（%）",
                        digits: _ltChallengeDigits,
                        length: 3,
                        onChanged:
                            (val) => setState(() => _ltChallengeDigits = val),
                      ),
                      DigitInputField(
                        label: "チャレンジ突破率（%）",
                        digits: _ltBreakDigits,
                        length: 3,
                        onChanged:
                            (val) => setState(() => _ltBreakDigits = val),
                      ),
                      DigitInputField(
                        label: "LT継続率（%）",
                        digits: _ltKeizokuDigits,
                        length: 2,
                        onChanged:
                            (val) => setState(() => _ltKeizokuDigits = val),
                      ),
                      const Text(
                        "LT中出玉振り分け",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...List.generate(_ltDedamaDigitsList.length, (i) {
                        return Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: DigitInputField(
                                label: "出玉数",
                                digits: _ltDedamaDigitsList[i],
                                length: 4,
                                onChanged:
                                    (val) => setState(
                                      () => _ltDedamaDigitsList[i] = val,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              flex: 2,
                              child: DigitInputField(
                                label: "上乗せ出玉数（任意）",
                                digits: _ltAddDedamaDigitsList[i],
                                length: 4,
                                onChanged:
                                    (val) => setState(
                                      () => _ltAddDedamaDigitsList[i] = val,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              flex: 2,
                              child: DigitInputField(
                                label: "ループ率（%）",
                                digits: _ltLoopRateDigitsList[i],
                                length: 2,
                                enabled: _ltAddDedamaDigitsList[i].any(
                                  (d) => d != 0,
                                ),
                                onChanged:
                                    (val) => setState(
                                      () => _ltLoopRateDigitsList[i] = val,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              flex: 1,
                              child: DigitInputField(
                                label: "割合（%）",
                                digits: _ltDedamaRateDigitsList[i],
                                length: 3,
                                onChanged:
                                    (val) => setState(
                                      () => _ltDedamaRateDigitsList[i] = val,
                                    ),
                              ),
                            ),
                            if (_ltDedamaDigitsList.length > 1 && i > 0)
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () => _removeLtDedama(i),
                              ),
                          ],
                        );
                      }),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _addLtDedama,
                          icon: const Icon(Icons.add),
                          label: const Text("LT出玉追加"),
                        ),
                      ),
                    ],
                  ),
                if (_ltMode == LtMode.upgrade)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DigitInputField(
                        label: "LT振り分け率（%）",
                        digits: _ltUpgradeRateDigits,
                        length: 3,
                        onChanged:
                            (val) => setState(() => _ltUpgradeRateDigits = val),
                      ),
                      DigitInputField(
                        label: "LT継続率（%）",
                        digits: _ltKeizokuDigits,
                        length: 2,
                        onChanged:
                            (val) => setState(() => _ltKeizokuDigits = val),
                      ),
                      const Text(
                        "LT中出玉振り分け",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...List.generate(_ltDedamaDigitsList.length, (i) {
                        return Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: DigitInputField(
                                label: "出玉数",
                                digits: _ltDedamaDigitsList[i],
                                length: 4,
                                onChanged:
                                    (val) => setState(
                                      () => _ltDedamaDigitsList[i] = val,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              flex: 2,
                              child: DigitInputField(
                                label: "上乗せ出玉数（任意）",
                                digits: _ltAddDedamaDigitsList[i],
                                length: 4,
                                onChanged:
                                    (val) => setState(
                                      () => _ltAddDedamaDigitsList[i] = val,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              flex: 2,
                              child: DigitInputField(
                                label: "ループ率（%）",
                                digits: _ltLoopRateDigitsList[i],
                                length: 2,
                                enabled: _ltAddDedamaDigitsList[i].any(
                                  (d) => d != 0,
                                ),
                                onChanged:
                                    (val) => setState(
                                      () => _ltLoopRateDigitsList[i] = val,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              flex: 1,
                              child: DigitInputField(
                                label: "割合（%）",
                                digits: _ltDedamaRateDigitsList[i],
                                length: 3,
                                onChanged:
                                    (val) => setState(
                                      () => _ltDedamaRateDigitsList[i] = val,
                                    ),
                              ),
                            ),
                            if (_ltDedamaDigitsList.length > 1 && i > 0)
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () => _removeLtDedama(i),
                              ),
                          ],
                        );
                      }),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _addLtDedama,
                          icon: const Icon(Icons.add),
                          label: const Text("LT出玉追加"),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 18),
                Center(
                  child: ElevatedButton(
                    onPressed: _calculate,
                    child: const Text("計算する", style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),
                if (_result.isNotEmpty)
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        _result,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            TextEditingController _titleController =
                                TextEditingController();
                            return AlertDialog(
                              title: const Text("保存データタイトル"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _titleController,
                                    decoration: const InputDecoration(
                                      hintText: "例：ライトミドル検証用",
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text("入力した内容と計算結果を保存しますか？"),
                                ],
                              ),
                              actionsAlignment: MainAxisAlignment.end,
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text("キャンセル"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final title =
                                        _titleController.text.trim().isEmpty
                                            ? "無題の保存データ"
                                            : _titleController.text.trim();

                                    final now = DateTime.now();
                                    final resultText = _result;

                                    // 保存処理を呼び出す（後で定義）
                                    _saveData(title, now, resultText);

                                    Navigator.of(ctx).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("「$title」を保存しました"),
                                      ),
                                    );
                                  },
                                  child: const Text("保存"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text("保存"),
                    ),
                    const SizedBox(width: 32),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      onPressed: _confirmReset, // 後述
                      child: const Text(
                        "リセット",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
