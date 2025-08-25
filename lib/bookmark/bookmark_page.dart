import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'bookmarks_notifier.dart';
import '../sidebar/custom_appbar.dart'; // ✅ panggil file custom appbar

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // ✅ Panggil CustomAppBar
          CustomAppBar(
            title: "Bookmark CCTV",
            onBack: () => Navigator.pop(context),
          ),

          // ISI LIST CCTV
          Expanded(
            child: ValueListenableBuilder<List<Map<String, String>>>(
              valueListenable: bookmarksNotifier,
              builder: (context, bookmarks, child) {
                if (bookmarks.isEmpty) {
                  return const Center(
                    child: Text("Belum ada CCTV yang dibookmark"),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 12),
                  itemCount: bookmarks.length,
                  itemBuilder: (context, index) {
                    final cctv = bookmarks[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Live CCTV preview pakai InAppWebView
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: SizedBox(
                              height: 200,
                              child: InAppWebView(
                                initialUrlRequest: URLRequest(
                                  url: WebUri(cctv['url']!),
                                ),
                                initialSettings: InAppWebViewSettings(
                                  javaScriptEnabled: true,
                                  mediaPlaybackRequiresUserGesture: false,
                                ),
                              ),
                            ),
                          ),
                          // Nama CCTV
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              cctv['name']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
    );
  }
}
