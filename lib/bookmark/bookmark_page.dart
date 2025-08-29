import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'bookmarks_notifier.dart';
import '../sidebar/custom_appbar.dart';
import '../pages/cctv_page.dart';
import '../models/cctv_model.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  void _hapusBookmark(int index) {
    final current = List<Map<String, String>>.from(bookmarksNotifier.value);
    current.removeAt(index);
    bookmarksNotifier.value = current; // update notifier
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          CustomAppBar(
            title: "Bookmark CCTV",
            onBack: () => Navigator.pop(context),
          ),

          Expanded(
            child: ValueListenableBuilder<List<Map<String, String>>>(
              valueListenable: bookmarksNotifier,
              builder: (context, bookmarks, child) {
                if (bookmarks.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada CCTV yang dibookmark",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: bookmarks.length,
                  itemBuilder: (context, index) {
                    final item = bookmarks[index];

                    final cctv = CCTV(
                      id: index,
                      name: item['name'] ?? "Unknown",
                      url: item['url'] ?? "",
                      latitude: 0.0,
                      longitude: 0.0,
                      isActive: true,
                      region: "Banda Aceh",
                      address: null,
                    );

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CCTVPage(cctv: cctv),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: 140,
                                        height: 90,
                                        child: InAppWebView(
                                          initialUrlRequest: URLRequest(
                                            url: WebUri(item['url'] ?? ""),
                                          ),
                                          initialSettings: InAppWebViewSettings(
                                            javaScriptEnabled: true,
                                            mediaPlaybackRequiresUserGesture:
                                                false,
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        bottom: 6,
                                        right: 6,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.7,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: const Text(
                                            "LIVE",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Judul
                                          Expanded(
                                            child: Text(
                                              item['name'] ?? "",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          PopupMenuButton<String>(
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors.grey,
                                            ),
                                            onSelected: (value) {
                                              if (value == 'hapus') {
                                                _hapusBookmark(index);
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: 'hapus',
                                                child: Text("Hapus Bookmark"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "CCTV - Banda Aceh",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Ditambahkan ke bookmark",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
