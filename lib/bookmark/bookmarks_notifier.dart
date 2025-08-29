import 'package:flutter/material.dart';

ValueNotifier<List<Map<String, String>>> bookmarksNotifier =
    ValueNotifier<List<Map<String, String>>>([]);

void toggleBookmark(Map<String, String> cctv) {
  final currentList = bookmarksNotifier.value;
  final exists = currentList.any((item) => item['name'] == cctv['name']);

  if (exists) {
    bookmarksNotifier.value = currentList
        .where((item) => item['name'] != cctv['name'])
        .toList();
  } else {
    bookmarksNotifier.value = [...currentList, cctv];
  }
}
