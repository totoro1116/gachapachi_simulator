import 'package:flutter/material.dart';

// キャラモデル
class GachaCharacter {
  String name;
  double probability;
  GachaCharacter({required this.name, required this.probability});

  GachaCharacter copyWith({String? name, double? probability}) {
    return GachaCharacter(
      name: name ?? this.name,
      probability: probability ?? this.probability,
    );
  }
}

// レアリティモデル
class GachaRarity {
  String rarityName;
  List<GachaCharacter> characters;
  GachaRarity({required this.rarityName, required this.characters});

  GachaRarity copyWith({String? rarityName, List<GachaCharacter>? characters}) {
    return GachaRarity(
      rarityName: rarityName ?? this.rarityName,
      characters: characters ?? this.characters,
    );
  }
}

// Providerで管理するStateクラス
class GachaSimuState extends ChangeNotifier {
  List<GachaRarity> rarities = [
    GachaRarity(
      rarityName: '',
      characters: [GachaCharacter(name: '', probability: 0.5)],
    ),
  ];
  List<int> gachaCountDigits = [0, 1, 0]; // 10回
  // 必要なら他にも履歴や入力補助もここで管理可

  void setRarities(List<GachaRarity> newRarities) {
    rarities = newRarities;
    notifyListeners();
  }

  void setGachaCount(List<int> newDigits) {
    gachaCountDigits = newDigits;
    notifyListeners();
  }
}
