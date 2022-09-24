import 'dart:core';

import 'package:flutter/foundation.dart';

class ListItem {
  Map<String, dynamic> id3Tags;
  String headerValue;
  Uint8List bytes;
  late bool isExpanded;
  late MetadataItem song;

  ListItem({
    required this.id3Tags,
    required this.headerValue,
    required this.bytes,
  }) {
    isExpanded = false;
    String album = "";
    if (id3Tags['Album'] != null) album = id3Tags['Album'];
    song = MetadataItem(
        artist: id3Tags['Artist'], title: id3Tags['Title'], album: album);
  }
}

class MetadataItem {
  String artist;
  String title;
  String album;

  MetadataItem({
    required this.artist,
    required this.title,
    required this.album,
  });
}
