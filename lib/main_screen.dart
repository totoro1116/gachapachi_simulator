import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // ←追加！
import 'widgets/ad_banner.dart';
import 'pachinko_form.dart';
import 'gachamode_screen.dart';
import 'hamari_screen.dart';
import 'setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _actionCount = 0;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    _loadActionCount();
  }

  Future<void> _loadActionCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _actionCount = prefs.getInt('actionCount') ?? 0;
    });
  }

  Future<void> _saveActionCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('actionCount', _actionCount);
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // テストID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  // これを各画面から呼び出す！
  void onAction() {
    setState(() {
      _actionCount++;
    });
    _saveActionCount();
    if (_actionCount % 10 == 0 && _interstitialAd != null) {
      _interstitialAd!.show();
      _loadInterstitialAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      PachinkoForm(
        onTabChange: (i) => setState(() => _selectedIndex = i),
        onAction: onAction, // ←追加！
      ),
      GachaModeScreen(
        onTabChange: (i) => setState(() => _selectedIndex = i),
        onAction: onAction, // ←追加！
      ),
      HamariScreen(
        onTabChange: (i) => setState(() => _selectedIndex = i),
        onAction: onAction, // ←追加！
      ),
      SettingScreen(
        onTabChange: (i) => setState(() => _selectedIndex = i),
        // 設定画面にはonAction不要
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: screens[_selectedIndex],
          ),
          Align(alignment: Alignment.bottomCenter, child: const AdBanner()),
        ],
      ),
    );
  }
}
