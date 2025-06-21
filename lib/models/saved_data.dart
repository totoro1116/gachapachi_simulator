import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// saved_data.dart
class SavedPachiData {
  String title;
  final DateTime savedAt;
  final String resultText;
  final String specText;

  SavedPachiData({
    required this.title,
    required this.savedAt,
    required this.resultText,
    required this.specText,
  });
  // 追加: Mapに変換
  Map<String, dynamic> toJson() => {
    'title': title,
    'savedAt': savedAt.toIso8601String(),
    'resultText': resultText,
    'specText': specText,
  };

  // 追加: Mapから生成
  factory SavedPachiData.fromJson(Map<String, dynamic> json) => SavedPachiData(
    title: json['title'] as String,
    savedAt: DateTime.parse(json['savedAt'] as String),
    resultText: json['resultText'] as String,
    specText: json['specText'] as String,
  );
}

// グローバル保存リスト
List<SavedPachiData> savedPachiList = [];

// 保存
Future<void> saveSavedPachiList() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = jsonEncode(savedPachiList.map((e) => e.toJson()).toList());
  await prefs.setString('savedPachiList', jsonString);
}

// 読込
Future<void> loadSavedPachiList() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('savedPachiList');
  if (jsonString != null) {
    final List<dynamic> decoded = jsonDecode(jsonString);
    savedPachiList.clear();
    savedPachiList.addAll(decoded.map((e) => SavedPachiData.fromJson(e)));
  }
}
