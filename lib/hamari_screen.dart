import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'setting_screen.dart';
import 'gachamode_screen.dart';
import 'pachinko_form.dart';
import 'top_tab_bar.dart';

final List<Map<String, dynamic>> probabilityComments = [
  {
    "min": 99,
    "comments": [
      "白内障手術の成功率くらいの確率（約98%）です。",
      "7回コイントスして1回以上裏が出るくらいの確率（約99%）です。",
      "100人中99人が当たるくらいの確率（約99%）です。",
    ],
  },
  {
    "min": 96,
    "comments": [
      "双子ではなく1人で生まれるくらいの確率（約96%）です。",
      "新生児が予定日±2週間以内に生まれるくらいの確率（約96%）です。",
      "日本の列車が遅延せずに運行されるくらいの確率（約95%）です。",
    ],
  },
  {
    "min": 93,
    "comments": [
      "トランプでエース以外を引くくらいの確率（約93%）です。",
      "45人のグループで「少なくとも2人が同じ誕生日」であるくらいの確率（約93%）です。",
      "四回コインを投げて少なくとも一回以上表が出るくらいの確率（約93%）です。",
    ],
  },
  {
    "min": 90,
    "comments": [
      "天気予報が当たるくらいの確率（約90%）です。",
      "NBA のトップ選手がフリースローを成功させるくらいの確率（約91%）です。",
      "アメリカで18～29歳がスマホを持っている割合（約92%）くらいの確率です。",
    ],
  },
  {
    "min": 87,
    "comments": [
      "アメリカで高校を卒業できるくらいの確率（約87%）です。",
      "日本人で右利きの割合（約87%）くらいの確率です。",
      "満員電車で座席に座れないくらいの確率（約87%）です。",
    ],
  },
  {
    "min": 84,
    "comments": [
      "サイコロを振って6以外が出るくらいの確率（約84%）です。",
      "桜の開花日に晴れるくらいの確率（約84%）です。",
      "清潔な飲料水（基本水源含む）を利用できる世界人口割合（約84%）くらいの確率です。",
    ],
  },
  {
    "min": 81,
    "comments": [
      "アメリカ人がスマートフォンを持っている割合（約81%）くらいの確率です。",
      "日本でインターネットが使える世帯の割合（約81%）くらいの確率です。",
      "1年のうち平日の割合（約81%）くらいの確率です。",
    ],
  },
  {
    "min": 78,
    "comments": [
      "アメリカの新しいビジネスが1年目を生き残るくらいの確率（約78%）です。",
      "自販機で欲しい飲み物が売り切れていないくらいの確率（約78%）です。",
      "高速道路の渋滞に遭遇しないくらいの確率（約78%）です。",
    ],
  },
  {
    "min": 75,
    "comments": [
      "サッカーのPKがゴールになるくらいの確率（約75%）です。",
      "大人が1日3食きちんと食べるくらいの確率（約75%）です。",
      "トランプを二枚引き少なくとも一枚が赤になるくらいの確率（約75%）です。",
    ],
  },
  {
    "min": 72,
    "comments": [
      "世界の人が安全に管理された飲み水を使えるくらいの確率（約72%）です。",
      "駅のホームで座れるくらいの確率（約72%）です。",
      "10人中7人がA型であるくらいの確率（約72%）です。",
    ],
  },
  {
    "min": 69,
    "comments": [
      "サイコロ2個を振って両方とも6以外になるくらいの確率（約69%）です。",
      "1週間で雨が降らない日のくらいの確率（約69%）です。",
      "高速バスが定刻通り到着するくらいの確率（約69%）です。",
    ],
  },
  {
    "min": 66,
    "comments": [
      "アメリカ大統領選の投票率くらいの確率（約66%）です。",
      "大学進学率くらいの確率（約66%）です。",
      "朝食を食べる人の割合（約66%）くらいの確率です。",
    ],
  },
  {
    "min": 63,
    "comments": [
      "世界の人がインターネットを使っているくらいの確率（約63%）です。",
      "東京都の世帯がペットを飼っていないくらいの確率（約63%）です。",
      "日本で冬に雪が積もらない日のくらいの確率（約63%）です。",
    ],
  },
  {
    "min": 60,
    "comments": [
      "世界の人口のアジア出身であるくらいの確率（約60%）です。",
      "大企業で男性が占める割合（約60%）くらいの確率です。",
      "宝くじを1枚だけ買う人の割合（約60%）くらいの確率です。",
    ],
  },
  {
    "min": 57,
    "comments": [
      "大人が肥満でないくらいの確率（約57%）です。",
      "お年玉をもらえる子供の割合（約57%）くらいの確率です。",
      "サラリーマンが休日に出勤しないくらいの確率（約57%）です。",
    ],
  },
  {
    "min": 54,
    "comments": [
      "日本の高校生が大学に進学するくらいの確率（約56%）です。",
      "友人との約束が守られるくらいの確率（約54%）です。",
      "女性が便秘を経験する割合（約51%）くらいの確率です。",
    ],
  },
  {
    "min": 51,
    "comments": [
      "赤ちゃんが男の子として生まれるくらいの確率（約51%）です。",
      "株価が上昇するくらいの確率（約51%）です。",
      "初詣で大吉が出るくらいの確率（約51%）です。",
    ],
  },
  {
    "min": 48,
    "comments": [
      "赤ちゃんが女の子として生まれるくらいの確率（約51%）です。",
      "朝、目覚まし時計で起きられるくらいの確率（約48%）です。",
      "クラスで出席番号が偶数になるくらいの確率（約48%）です。",
    ],
  },
  {
    "min": 45,
    "comments": [
      "世界の大人が太っているくらいの確率（約45%）です。",
      "正月太りする人の割合（約45%）くらいの確率です。",
      "日本人で献血経験がある人の割合（約45%）くらいの確率です。",
    ],
  },
  {
    "min": 42,
    "comments": [
      "アメリカ人が幽霊の存在を信じているくらいの確率（約42%）です。",
      "自分の星座占いが当たるくらいの確率（約42%）です。",
      "納豆を好きな人の割合（約42%）くらいの確率です。",
    ],
  },
  {
    "min": 39,
    "comments": [
      "アメリカ人がUFOを信じているくらいの確率（約39%）です。",
      "世界でA型の血液型の人の割合（約39%）くらいの確率です。",
      "中学生でスマホを持っている割合（約39%）くらいの確率です。",
    ],
  },
  {
    "min": 36,
    "comments": [
      "カナダ人の約36%がO+型の血液型であるくらいの確率（約36%）です。",
      "日本の社会人が転職を経験するくらいの確率（約36%）です。",
      "コーヒーをブラックで飲む人の割合（約36%）くらいの確率です。",
    ],
  },
  {
    "min": 33,
    "comments": [
      "サイコロを2回振ってどちらかで6が出るくらいの確率（約33%）です。",
      "大学入試で合格するくらいの確率（約33%）です。",
      "ニューヨークの 1 日降水確率（平均）くらいの確率（約33%）です。",
    ],
  },
  {
    "min": 30,
    "comments": [
      "ロンドンで1日雨が降るくらいの確率（約30%）です。",
      "バレンタインデーにチョコをもらえるくらいの確率（約30%）です。",
      "1月に雪が降る日のくらいの確率（約30%）です。",
    ],
  },
  {
    "min": 27,
    "comments": [
      "トランプで絵札を引くくらいの確率（約27%）です。",
      "日本の高校生で部活動に入っていない割合（約27%）くらいの確率です。",
      "コンビニで新商品が売り切れているくらいの確率（約27%）です。",
    ],
  },
  {
    "min": 24,
    "comments": [
      "西暦でうるう年が訪れるくらいの確率（約24%）です。",
      "夏休みに旅行に行く人の割合（約24%）くらいの確率です。",
      "ペットとして猫を飼っている家庭の割合（約24%）くらいの確率です。",
    ],
  },
  {
    "min": 21,
    "comments": [
      "世界の大人で喫煙している人の割合（約21%）くらいの確率です。",
      "歯磨き粉のチューブを最後まで使い切る前に新しいのを開けるくらいの確率（約20%）です。",
      "フルマラソンを完走できる人の割合（約21%）くらいの確率です。",
    ],
  },
  {
    "min": 18,
    "comments": [
      "サイコロ1回で6が出るくらいの確率（約18%）です。",
      "成人男性で身長180cm以上の割合（約18%）くらいの確率です。",
      "サイコロを二個振って合計が7になるくらいの確率（約17%）です。",
    ],
  },
  {
    "min": 15,
    "comments": [
      "アメリカ人の喫煙者の割合（約15%）くらいの確率です。",
      "東京23区で一人暮らしをしている人の割合（約15%）くらいの確率です。",
      "20面ダイスで1～3を出すくらいの確率（約15%）です。",
    ],
  },
  {
    "min": 12,
    "comments": [
      "左利きの人の割合（約12%）くらいの確率です。",
      "大企業で女性が役員である割合（約12%）くらいの確率です。",
      "トランプで黒の絵札を引くくらいの確率（約12%）です。",
    ],
  },
  {
    "min": 9,
    "comments": [
      "赤い車に乗っている人の割合（約9%）くらいの確率です。",
      "A型インフルエンザの流行率くらいの確率（約9%）です。",
      "日本で雪が積もる日の割合（約9%）くらいの確率です。",
    ],
  },
  {
    "min": 6,
    "comments": [
      "O-型（輸血の万能型）を持つ人の割合（約6%）くらいの確率です。",
      "猫の毛色が白の割合くらいの確率（約6%）です。",
      "日本の成人女性で身長170cm以上の割合（約6%）くらいの確率です。",
    ],
  },
  {
    "min": 3,
    "comments": [
      "双子が生まれるくらいの確率（約3%）です。",
      "国内で1年に地震が震度5以上になるくらいの確率（約3%）です。",
      "1年間で財布を落とす人の割合（約3%）くらいの確率です。",
    ],
  },
  {
    "min": 1,
    "comments": [
      "アメリカ人が一年間で交通事故にあうくらいの確率（約1%）です。",
      "トランプで任意の一枚を引くくらいの確率（約2%）です。",
      "外国人と結婚する日本人の割合（約1%）くらいの確率です。",
    ],
  },
  {
    "min": 0,
    "comments": [
      "雷に打たれる確率は約0.0001%。",
      "日本で同姓同名の人と出会うくらい確率は約0.01%です。",
      "一年で彗星を肉眼で見ることができる確率は約0.2%です。",
      "ロイヤルストレートフラッシュの出現率は約0.000154%です",
      "パワーボール（宝くじ）で一等が当たる確率は約0.00000034 %です",
      "ブルー・ロブスターが捕獲される確率は約0.00005 %です",
    ],
  },
];

String getProbabilityComment(double percent) {
  for (final item in probabilityComments) {
    final comments = (item["comments"] ?? <String>[]) as List<String>;
    if (percent >= item["min"] && comments.isNotEmpty) {
      final rand = Random();
      return comments[rand.nextInt(comments.length)];
    }
  }
  return "非常に珍しい出来事レベルの確率です。";
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
  final void Function(int)? onTabChange;
  final VoidCallback? onAction;
  const HamariScreen({Key? key, this.onTabChange, this.onAction})
    : super(key: key);

  @override
  State<HamariScreen> createState() => _HamariScreenState();
}

class _HamariScreenState extends State<HamariScreen> {
  List<int> _bunboDigits = [0, 3, 1, 9];
  List<int> _countDigits = [1, 0, 0, 0];

  String? _resultText;
  double? _percentAtaru;
  double? _hamariPercent; // ← 追加！

  int _digitsToInt(List<int> d) => d.fold(0, (a, b) => a * 10 + b);

  void _calcResult() {
    setState(() {
      _resultText = null;
      _percentAtaru = null;
      _hamariPercent = null;
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
    double prob = pow(1 - p, count).toDouble();
    double percent = prob * 100;
    double percentAtaru = (1 - prob) * 100;
    double oneIn = 1 / prob;
    setState(() {
      _resultText =
          "$count回転ハマる確率は${percent.toStringAsFixed(2)}%（1/${oneIn.toStringAsFixed(0)}）";
      _hamariPercent = percent;
      _percentAtaru = percentAtaru;
    });
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
              TopTabBar(
                current: TopTabType.hamari,
                onTabChange: widget.onTabChange,
              ),
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
                  onPressed: () {
                    _calcResult();
                    widget.onAction?.call();
                  },
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
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (_percentAtaru != null)
                      Text("※当たる確率は${_percentAtaru!.toStringAsFixed(2)}%"),
                    const SizedBox(height: 8),
                    if (_hamariPercent != null)
                      Text(
                        getProbabilityComment(_hamariPercent!),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
