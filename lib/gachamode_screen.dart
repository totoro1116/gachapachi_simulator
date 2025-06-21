import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'top_tab_bar.dart';

class GachaCountInputField extends StatelessWidget {
  final String label;
  final List<int> digits; // [百,十,一]
  final ValueChanged<List<int>> onChanged;
  final bool enabled;

  const GachaCountInputField({
    super.key,
    required this.label,
    required this.digits,
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
                            children: [
                              // 百の位（0 or 1のみ！）
                              SizedBox(
                                width: 46,
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: temp[0],
                                  ),
                                  itemExtent: 34,
                                  onSelectedItemChanged: (val) => temp[0] = val,
                                  children: List.generate(
                                    2,
                                    (j) => Center(
                                      child: Text(
                                        "$j",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // 十の位
                              SizedBox(
                                width: 46,
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: temp[1],
                                  ),
                                  itemExtent: 34,
                                  onSelectedItemChanged: (val) => temp[1] = val,
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
                              ),
                              // 一の位
                              SizedBox(
                                width: 46,
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: temp[2],
                                  ),
                                  itemExtent: 34,
                                  onSelectedItemChanged: (val) => temp[2] = val,
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
                              ),
                            ],
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
            hintText: '---',
            enabled: enabled,
          ),
          controller: TextEditingController(text: valueStr),
          style: TextStyle(color: enabled ? Colors.black : Colors.grey),
        ),
      ),
    );
  }
}

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

class GachaCharacter {
  String name;
  double probability;

  GachaCharacter({required this.name, required this.probability});
}

class GachaRarity {
  String rarityName;
  List<GachaCharacter> characters;

  GachaRarity({required this.rarityName, required this.characters});
}

class GachaResult {
  Map<String, int> charCount = {}; // キャラ名ごと
  Map<String, int> rarityCount = {}; // レアリティ名ごと
  int total = 0;
}

class GachaModeScreen extends StatefulWidget {
  const GachaModeScreen({Key? key}) : super(key: key);

  @override
  State<GachaModeScreen> createState() => _GachaModeScreenState();
}

class _GachaModeScreenState extends State<GachaModeScreen> {
  List<GachaRarity> rarities = [
    GachaRarity(
      rarityName: '',
      characters: [GachaCharacter(name: '', probability: 0.5)],
    ),
  ];

  List<int> gachaCountDigits = [0, 1, 0]; // 10回（百・十・一）
  final int maxPerSim = 100;

  // 累計結果
  GachaResult cumulativeResult = GachaResult();

  // 入力履歴（ここでは画面内保持、SharedPreferences保存も拡張可能）
  Set<String> rarityHistory = {'SSR', 'SR', 'R'};
  Set<String> charHistory = {};

  // バリデーション/警告
  String warningMessage = '';

  // シミュレーション実行
  void runSimulation(int count) {
    setState(() {
      warningMessage = '';
    });

    // バリデーション
    double totalProb = 0.0;
    for (var rarity in rarities) {
      for (var chara in rarity.characters) {
        totalProb += chara.probability;
      }
    }
    if (totalProb.abs() < 0.01) {
      setState(() {
        warningMessage = '合計確率が0%です。';
      });
      return;
    }
    if ((totalProb - 100).abs() > 0.01) {
      setState(() {
        warningMessage = '合計確率が100%ではありません！（現在 $totalProb %）';
      });
      return;
    }

    // キャラ一覧を1リスト化
    List<Map<String, dynamic>> pool = [];
    for (var rarity in rarities) {
      for (var chara in rarity.characters) {
        pool.add({
          'rarity': rarity.rarityName.isEmpty ? 'SSR' : rarity.rarityName,
          'name': chara.name.isEmpty ? 'キャラ名未設定' : chara.name,
          'prob': chara.probability,
        });
      }
    }

    // プールを重みで分布にする
    List<String> charaDrawList = [];
    for (var c in pool) {
      int count = (c['prob'] * 10).round(); // 小数点以下精度↑
      for (int i = 0; i < count; i++) {
        charaDrawList.add("${c['rarity']}::${c['name']}");
      }
    }
    // シャッフル
    charaDrawList.shuffle();

    // 累積更新
    Random random = Random();
    for (int i = 0; i < count; i++) {
      int idx = random.nextInt(charaDrawList.length);
      String picked = charaDrawList[idx];
      // 集計
      cumulativeResult.charCount[picked] =
          (cumulativeResult.charCount[picked] ?? 0) + 1;
      String rarity = picked.split('::')[0];
      cumulativeResult.rarityCount[rarity] =
          (cumulativeResult.rarityCount[rarity] ?? 0) + 1;
      cumulativeResult.total += 1;
    }
  }

  // 入力系UI
  Widget buildRarityBlock(int rarityIndex) {
    final rarity = rarities[rarityIndex];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                // レアリティ名入力
                SizedBox(
                  width: 90,
                  child: TextFormField(
                    initialValue: rarity.rarityName,
                    decoration: InputDecoration(
                      labelText: 'レアリティ名',
                      hintText: '例: ssr',
                    ),
                    onChanged: (v) {
                      setState(() {
                        rarity.rarityName = v;
                        rarityHistory.add(v);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // レアリティ削除
                if (rarities.length > 1 && rarityIndex != 0)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        rarities.removeAt(rarityIndex);
                      });
                    },
                  ),
              ],
            ),
            // キャラリスト
            ...List.generate(rarity.characters.length, (charIdx) {
              final chara = rarity.characters[charIdx];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        initialValue: chara.name,
                        decoration: InputDecoration(
                          labelText: 'キャラ名',
                          hintText: '例: アリス',
                        ),
                        onChanged: (v) {
                          setState(() {
                            chara.name = v;
                            charHistory.add(v);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        initialValue: chara.probability.toString(),
                        decoration: const InputDecoration(labelText: '確率（％）'),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (v) {
                          setState(() {
                            chara.probability = double.tryParse(v) ?? 0;
                          });
                        },
                      ),
                    ),
                    // キャラ削除
                    if (rarity.characters.length > 1 && charIdx != 0)
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () {
                          setState(() {
                            rarity.characters.removeAt(charIdx);
                          });
                        },
                      ),
                  ],
                ),
              );
            }),
            // キャラ追加ボタン
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('キャラ追加'),
                onPressed: () {
                  setState(() {
                    double lastProb = 0.0;
                    if (rarity.characters.isNotEmpty) {
                      lastProb = rarity.characters.last.probability;
                    }
                    rarity.characters.add(
                      GachaCharacter(name: '', probability: lastProb),
                    );
                  });
                },
              ),
            ),
            // レアリティ合計確率表示
            Row(
              children: [
                const Text('合計:'),
                Text(
                  '${rarity.characters.fold(0.0, (sum, c) => sum + c.probability)} %',
                  style: TextStyle(
                    color:
                        (rarity.characters.fold(
                                          0.0,
                                          (sum, c) => sum + c.probability,
                                        ) -
                                        100)
                                    .abs() >
                                0.01
                            ? Colors.red
                            : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 結果表示
  Widget buildResultArea() {
    if (cumulativeResult.total == 0) return const SizedBox();
    return Card(
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '【試行回数】${cumulativeResult.total} 回',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            ...rarities
                .where(
                  (rarity) => cumulativeResult.rarityCount.containsKey(
                    rarity.rarityName.isEmpty ? 'SSR' : rarity.rarityName,
                  ),
                )
                .map((rarity) {
                  final key =
                      rarity.rarityName.isEmpty ? 'SSR' : rarity.rarityName;
                  final count = cumulativeResult.rarityCount[key] ?? 0;
                  final percent =
                      cumulativeResult.total > 0
                          ? ((count / cumulativeResult.total) * 100)
                              .toStringAsFixed(2)
                          : "0.00";
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('【$key】合計：$count 回（$percent%）'),
                  );
                }),

            const SizedBox(height: 8),
            ...rarities
                .where(
                  (rarity) => cumulativeResult.rarityCount.containsKey(
                    rarity.rarityName.isEmpty ? 'SSR' : rarity.rarityName,
                  ),
                )
                .expand((rarity) {
                  final key =
                      rarity.rarityName.isEmpty ? 'SSR' : rarity.rarityName;
                  return rarity.characters
                      .where((chara) {
                        final charKey =
                            '$key::${chara.name.isEmpty ? "キャラ名未設定" : chara.name}';
                        return cumulativeResult.charCount.containsKey(charKey);
                      })
                      .map((chara) {
                        final charKey =
                            '$key::${chara.name.isEmpty ? "キャラ名未設定" : chara.name}';
                        final count = cumulativeResult.charCount[charKey] ?? 0;
                        final percent =
                            cumulativeResult.total > 0
                                ? ((count / cumulativeResult.total) * 100)
                                    .toStringAsFixed(2)
                                : "0.00";
                        return Padding(
                          padding: const EdgeInsets.only(left: 12, bottom: 2),
                          child: Text(
                            ' - $key（${chara.name.isEmpty ? "キャラ名未設定" : chara.name}）：$count 回（$percent%）',
                          ),
                        );
                      });
                }),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('追加ガチャ'),
                  onPressed: () {
                    int gachaCount =
                        gachaCountDigits[0] * 100 +
                        gachaCountDigits[1] * 10 +
                        gachaCountDigits[2];
                    if (gachaCount < 1 || gachaCount > 100) {
                      setState(() {
                        warningMessage = 'ガチャ回数は1～100回の間で入力してください。';
                      });
                      return;
                    }
                    setState(() {
                      warningMessage = '';
                    });
                    runSimulation(gachaCount); // 累積で追加
                  },
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                  ),
                  child: const Text(
                    'リセット',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    setState(() {
                      cumulativeResult = GachaResult();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // メインUI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0), // パチンコと同じ18.0
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopTabBar(current: TopTabType.gacha), // ←タブバー！
                const SizedBox(height: 10),
                ...List.generate(rarities.length, (i) => buildRarityBlock(i)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add_circle),
                    label: const Text('レアリティ追加'),
                    onPressed: () {
                      setState(() {
                        rarities.add(
                          GachaRarity(
                            rarityName: '',
                            characters: [
                              GachaCharacter(name: '', probability: 0),
                            ],
                          ),
                        );
                      });
                    },
                  ),
                ),
                const Divider(),

                // === ガチャ回数とボタンはRowで並べる ===
                Row(
                  children: [
                    Expanded(
                      child: GachaCountInputField(
                        label: 'ガチャ回数（最大100）',
                        digits: gachaCountDigits,
                        onChanged: (val) {
                          setState(() {
                            gachaCountDigits = List<int>.from(val);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      child: const Text('シミュレーション実行'),
                      onPressed: () {
                        int gachaCount =
                            gachaCountDigits[0] * 100 +
                            gachaCountDigits[1] * 10 +
                            gachaCountDigits[2];
                        if (gachaCount < 1 || gachaCount > 100) {
                          setState(() {
                            warningMessage = 'ガチャ回数は1～100回の間で入力してください。';
                          });
                          return;
                        }
                        setState(() {
                          cumulativeResult = GachaResult(); // ★ここでリセット
                          warningMessage = '';
                        });
                        runSimulation(gachaCount); // ★新規集計
                      },
                    ),
                  ],
                ),

                // === 警告表示はRowの外、Column内で ===
                if (warningMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      warningMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                // === 結果エリアもColumn内で ===
                buildResultArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
