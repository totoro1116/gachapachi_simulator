import 'package:flutter/material.dart';
import 'top_tab_bar.dart'; // 共通タブバーWidgetをimport
import 'saved_data_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'top_tab_bar.dart';

const String inquiryEmail = 'kokoapp.info@gmail.com';
const String privacyPolicyUrl =
    'https://totoro1116.github.io/privacy-policy/privacy_gacha_pachi.html';

class SettingScreen extends StatelessWidget {
  final void Function(int)? onTabChange;
  const SettingScreen({super.key, this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopTabBar(
                  current: TopTabType.settings,
                  onTabChange: onTabChange,
                ),
                const SizedBox(height: 10),
                const Text(
                  "設定",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 24, thickness: 1),
                // ↓ここから仮の設定項目
                ListTile(
                  leading: const Icon(Icons.save),
                  title: const Text('保存データ'),
                  subtitle: const Text('計算結果の保存・呼び出し・編集・削除'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SavedDataScreen(),
                      ),
                    );
                  },
                ),

                //ListTile(
                //leading: const Icon(Icons.palette),
                //title: const Text('テーマ設定'),
                //subtitle: const Text('ダーク/ライトモード切替（未実装）'),
                //onTap: () {
                // テーマ設定画面へ（今後実装）
                //},
                //),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('このアプリについて'),
                  subtitle: const Text('ガチャパチシミュ - パチンコ＆ガチャ確率計算アプリ v1.0'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text('このアプリについて'),
                            content: const SingleChildScrollView(
                              child: Text(
                                'ガチャ・パチンコ確率シミュレーター v1.0\n\n'
                                '開発・配布：Koko AI Lab\n\n'
                                'このアプリは、パチンコやガチャ（ソーシャルゲーム等）の確率計算やシミュレーションを簡単に行える無料ツールです。\n'
                                '入力したスペックに基づいて、当たり確率や連チャン期待値、出玉期待値などを手軽に計算・保存できます。\n\n'
                                '【確率比較について】\n'
                                '画面上に表示される現実世界の確率例は、あくまで参考値・目安として掲載しています。'
                                'データや出典、年・地域によって数値が異なる場合がありますので、お遊びや雑学としてお楽しみください。\n\n'
                                '【データ・プライバシーについて】\n'
                                'アプリ内のデータはすべて端末内にのみ保存されます。\n'
                                '個人情報や入力内容が外部に送信されることはありません。\n\n'
                                '【広告について】\n'
                                '本アプリには運営維持のため広告が表示されます。\n\n'
                                'ご質問やご要望、不具合報告は「お問い合わせ」からどうぞ。\n\n'
                                '© 2025 Koko AI Lab',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("閉じる"),
                              ),
                            ],
                          ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.contact_mail),
                  title: const Text('お問い合わせ'),
                  subtitle: const Text('不具合や要望はこちらから'),
                  onTap: () async {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: inquiryEmail,
                      query: Uri.encodeFull('subject=【アプリお問い合わせ】'),
                    );

                    final bool? result = await showDialog<bool>(
                      context: context,
                      builder:
                          (ctx) => AlertDialog(
                            title: const Text('お問い合わせ'),
                            content: const Text('メールアプリを起動してお問い合わせしますか？'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('キャンセル'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                    );

                    if (result == true) {
                      if (await canLaunchUrl(emailUri)) {
                        await launchUrl(emailUri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('メールアプリが見つかりませんでした')),
                        );
                      }
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('プライバシーポリシー'),
                  subtitle: const Text('データの取り扱いについて'),
                  onTap: () async {
                    final Uri url = Uri.parse(privacyPolicyUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ブラウザを開けませんでした')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
