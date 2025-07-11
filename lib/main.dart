import 'package:flutter/material.dart';
import 'main_screen.dart'; // ← 共通化した親Widgetをimport
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize(); // ← ここを追加
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(), // ← ここをMainScreenにする！
    );
  }
}
