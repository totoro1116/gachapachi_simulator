import 'package:flutter/material.dart';
import 'top_tab_bar.dart';
import 'package:gacha_simulator/models/saved_data.dart';

class SavedDataScreen extends StatefulWidget {
  const SavedDataScreen({super.key});

  @override
  State<SavedDataScreen> createState() => _SavedDataScreenState();
}

class _SavedDataScreenState extends State<SavedDataScreen> {
  @override
  void initState() {
    super.initState();
    loadSavedPachiList().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final reversedList = savedPachiList.reversed.toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopTabBar(current: TopTabType.settings),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "保存データ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    tooltip: '戻る',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1),
              Expanded(
                child:
                    reversedList.isEmpty
                        ? const Center(
                          child: Text(
                            "保存されたデータはまだありません",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                        : ListView.builder(
                          itemCount: reversedList.length,
                          itemBuilder: (context, index) {
                            final data = reversedList[index];
                            return ListTile(
                              leading: const Icon(Icons.note),
                              title: Text(data.title),
                              subtitle: Text(
                                "${data.savedAt.toLocal()}".split('.').first,
                                style: const TextStyle(fontSize: 12),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (ctx) => AlertDialog(
                                        title: GestureDetector(
                                          onTap: () {
                                            TextEditingController
                                            titleController =
                                                TextEditingController(
                                                  text: data.title,
                                                );

                                            showDialog(
                                              context: context,
                                              builder:
                                                  (editCtx) => AlertDialog(
                                                    title: const Text("タイトル編集"),
                                                    content: TextField(
                                                      controller:
                                                          titleController,
                                                      decoration:
                                                          const InputDecoration(
                                                            hintText: "タイトルを入力",
                                                          ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            () =>
                                                                Navigator.of(
                                                                  editCtx,
                                                                ).pop(),
                                                        child: const Text(
                                                          "キャンセル",
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            data.title =
                                                                titleController
                                                                        .text
                                                                        .trim()
                                                                        .isEmpty
                                                                    ? "無題"
                                                                    : titleController
                                                                        .text
                                                                        .trim();
                                                          });
                                                          await saveSavedPachiList();
                                                          Navigator.of(
                                                            editCtx,
                                                          ).pop();
                                                        },
                                                        child: const Text("保存"),
                                                      ),
                                                    ],
                                                  ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.edit,
                                                size: 20,
                                                color: Colors.deepPurple,
                                              ),
                                              const SizedBox(width: 6),
                                              Flexible(
                                                child: Text(
                                                  data.title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Text(
                                            "${data.specText}\n\n${data.resultText}",
                                          ),
                                        ),
                                        actions: [
                                          // 削除ボタン（左）
                                          TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (confirmCtx) => AlertDialog(
                                                      title: const Text(
                                                        "削除の確認",
                                                      ),
                                                      content: const Text(
                                                        "この保存データを削除してもよろしいですか？",
                                                      ),
                                                      actions: [
                                                        // 削除（左）
                                                        TextButton(
                                                          onPressed: () async {
                                                            setState(() {
                                                              savedPachiList
                                                                  .remove(data);
                                                            });
                                                            await saveSavedPachiList();
                                                            Navigator.of(
                                                              confirmCtx,
                                                            ).pop();
                                                            Navigator.of(
                                                              ctx,
                                                            ).pop();
                                                          },
                                                          child: const Text(
                                                            "削除する",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                        // キャンセル（右）
                                                        TextButton(
                                                          onPressed:
                                                              () =>
                                                                  Navigator.of(
                                                                    confirmCtx,
                                                                  ).pop(),
                                                          child: const Text(
                                                            "キャンセル",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              );
                                            },
                                            child: const Text(
                                              "削除",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          // 閉じるボタン（右）
                                          TextButton(
                                            onPressed:
                                                () => Navigator.of(ctx).pop(),
                                            child: const Text("閉じる"),
                                          ),
                                        ],
                                      ),
                                );
                              },
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
