import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../models/cctv_model.dart';
import '../bookmark/bookmarks_notifier.dart';

class CCTVPage extends StatefulWidget {
  final CCTV cctv;
  const CCTVPage({super.key, required this.cctv});

  @override
  State<CCTVPage> createState() => _CCTVPageState();
}

class _CCTVPageState extends State<CCTVPage>
    with SingleTickerProviderStateMixin {
  InAppWebViewController? _webViewController;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  bool _hasError = false;

  void _refreshFeed() {
    setState(() {
      _hasError = false;
    });
    _webViewController?.reload();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1F4E78),
                    Color.fromARGB(255, 93, 168, 233),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.cctv.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    ValueListenableBuilder<List<Map<String, String>>>(
                      valueListenable: bookmarksNotifier,
                      builder: (context, bookmarks, _) {
                        final isBookmarked = bookmarks.any(
                          (item) => item['name'] == widget.cctv.name,
                        );

                        return IconButton(
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: isBookmarked ? Colors.yellow : Colors.white,
                          ),
                          onPressed: () {
                            toggleBookmark({
                              'name': widget.cctv.name,
                              'url': widget.cctv.url,
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isBookmarked
                                      ? "Dihapus dari Bookmark"
                                      : "Ditambahkan ke Bookmark",
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Live CCTV Preview",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _hasError
                          ? Image.network(
                              "https://diskominfo.bandaacehkota.go.id/wp-content/uploads/sites/3/2024/03/LOGO-KOTA-BANDA-ACEH-Versi-01-1.png",
                              fit: BoxFit.contain,
                            )
                          : InAppWebView(
                              initialUrlRequest: URLRequest(
                                url: WebUri(widget.cctv.url),
                              ),
                              onWebViewCreated: (controller) {
                                _webViewController = controller;
                              },
                              onLoadError: (controller, url, code, message) {
                                setState(() {
                                  _hasError = true;
                                });
                              },
                              onLoadHttpError:
                                  (controller, url, statusCode, description) {
                                    setState(() {
                                      _hasError = true;
                                    });
                                  },
                              initialSettings: InAppWebViewSettings(
                                javaScriptEnabled: true,
                                mediaPlaybackRequiresUserGesture: false,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: _refreshFeed,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh Feed"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status: ${widget.cctv.isActive ? "Online" : "Offline"}",
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.cctv.isActive
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (widget.cctv.address != null)
                        Text(
                          "Lokasi: ${widget.cctv.address!}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      Text(
                        "Region: ${widget.cctv.region}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Text(
                    "Catatan: Pastikan koneksi internet stabil untuk melihat feed CCTV secara real-time.",
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
