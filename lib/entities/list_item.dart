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
    String artist, title, album;
    if (id3Tags['Artist'] != null) {
      artist = id3Tags['Artist'];
    } else {
      artist = headerValue.split(' – ').first;
    }
    if (id3Tags['Title'] != null) {
      title = id3Tags['Title'];
    } else {
      title = headerValue.split(' – ').last;
    }
    if (id3Tags['Album'] != null) {
      album = id3Tags['Album'];
    } else {
      album = "";
    }
    song = MetadataItem(artist: [artist], title: title, album: album);
  }
}

class MetadataItem {
  List<String> artist;
  String title;
  String album;
  List<String>? feat = [];

  MetadataItem({
    required this.artist,
    required this.title,
    required this.album,
    this.feat,
  });
}
