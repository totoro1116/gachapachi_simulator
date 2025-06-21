import 'package:flutter/material.dart';

class PadhinkoDetailSettingsPage extends StatefulWidget {
  const PadhinkoDetailSettingsPage({super.key});

  @override
  State<PadhinkoDetailSettingsPage> createState() =>
      _PadhinkoDetailSettingsPageState();
}

class _PadhinkoDetailSettingsPageState
    extends State<PadhinkoDetailSettingsPage> {
  List<String> atariList = [''];
  List<String> rightAtariList = [''];
  // 大当たり確率

  String customAtari = '';

  // 右打ち確率
  String rightAtari = '';

  // へそ振り分けリスト
  List<Map<String, dynamic>> hesoList = [
    {'出玉': '', 'タイプ': '確変ループ', '回数1': '', '回数2': '', '率1': '', '率2': ''},
  ];

  // 右打ち振り分けリスト（サンプル構造）
  List<Map<String, dynamic>> rightList = [
    {'出玉': '', 'タイプ': '確変ループ', '回数1': '', '回数2': '', '率1': '', '率2': ''},
  ];

  // LT中振り分けリスト（サンプル構造）
  List<Map<String, dynamic>> ltList = [
    {
      '出玉': '',
      '回数': '',
      'タイプ': '上乗せループ',
      '上乗せ率': '',
      '当たり確率': '',
      '抽選回数': '',
      '振り分け率': '',
    },
  ];

  // 計算結果
  bool showResult = false;
  String resultText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('パチンコモード 詳細設定'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 大当たり確率
            ...List.generate(atariList.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixText: '1/',
                          labelText:
                              index == 0 ? '大当たり確率' : '大当たり確率${index + 1}',
                          border: const UnderlineInputBorder(),
                        ),
                        onChanged: (v) => setState(() => atariList[index] = v),
                        controller: TextEditingController(
                          text: atariList[index],
                        ),
                      ),
                    ),
                    if (index != 0)
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        ),
                        tooltip: '削除',
                        onPressed:
                            () => setState(() => atariList.removeAt(index)),
                      ),
                  ],
                ),
              );
            }),
            // 追加ボタン
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add, color: Colors.purple),
                label: const Text('追加', style: TextStyle(color: Colors.purple)),
                onPressed: () => setState(() => atariList.add('')),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.purple,
                  textStyle: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // 右打ち確率
            ...List.generate(rightAtariList.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: index == 0 ? '右打ち確率' : '右打ち確率${index + 1}',
                          border: const UnderlineInputBorder(),
                        ),
                        onChanged:
                            (v) => setState(() => rightAtariList[index] = v),
                        controller: TextEditingController(
                          text: rightAtariList[index],
                        ),
                      ),
                    ),
                    if (index != 0)
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        ),
                        tooltip: '削除',
                        onPressed:
                            () =>
                                setState(() => rightAtariList.removeAt(index)),
                      ),
                  ],
                ),
              );
            }),
            // 追加ボタン
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add, color: Colors.purple),
                label: const Text('追加', style: TextStyle(color: Colors.purple)),
                onPressed: () => setState(() => rightAtariList.add('')),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.purple,
                  textStyle: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // --- へそ振り分け ---
            _buildHesoSection(),

            const Divider(height: 24),

            // --- 右打ち振り分け ---
            _buildRightSection(),

            const Divider(height: 24),

            // --- LT中振り分け ---
            _buildLTSection(),

            const Divider(height: 24),

            // --- 計算ボタン ---
            Center(
              child: ElevatedButton(
                child: const Text('計算する'),
                onPressed: () {
                  // 計算ロジックは後ほど
                  setState(() {
                    showResult = true;
                    resultText = 'ここに計算結果を表示（ロジック後ほど追加）';
                  });
                },
              ),
            ),

            // --- 結果表示 ---
            if (showResult)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                color: Colors.blue.shade50,
                child: Text(resultText),
              ),
          ],
        ),
      ),
    );
  }

  // --- へそ振り分け ---
  Widget _buildHesoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('へそ振り分け', style: TextStyle(fontWeight: FontWeight.bold)),
        ...hesoList.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: '出玉'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() => item['出玉'] = v),
                  ),
                  DropdownButton<String>(
                    value: item['タイプ'],
                    items:
                        ['確変ループ', 'ST', '時短', '通常', 'LT', 'LTチャレンジ', '確変＋時短']
                            .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)),
                            )
                            .toList(),
                    onChanged: (v) => setState(() => item['タイプ'] = v!),
                  ),
                  // 必要に応じて動的項目追加…
                  if (hesoList.length > 1)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: const Text('この振り分けを削除する'),
                        onPressed: () => setState(() => hesoList.removeAt(i)),
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            child: const Text('振り分け追加'),
            onPressed:
                () => setState(
                  () => hesoList.add({
                    '出玉': '',
                    'タイプ': '確変ループ',
                    '回数1': '',
                    '回数2': '',
                    '率1': '',
                    '率2': '',
                  }),
                ),
          ),
        ),
      ],
    );
  }

  // --- 右打ち振り分け ---
  Widget _buildRightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('右打ち振り分け', style: TextStyle(fontWeight: FontWeight.bold)),
        // ...rightList widget生成（サンプル。詳細はへそと同様に拡張可）
        Text('(サンプル: 右打ち振り分け入力欄をここに追加)'),
      ],
    );
  }

  // --- LT中振り分け ---
  Widget _buildLTSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('LT中振り分け', style: TextStyle(fontWeight: FontWeight.bold)),
        // ...ltList widget生成（サンプル。詳細はへそと同様に拡張可）
        Text('(サンプル: LT中振り分け入力欄をここに追加)'),
      ],
    );
  }
}
