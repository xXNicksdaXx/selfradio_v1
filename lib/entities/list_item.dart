import 'dart:core';

import 'package:flutter/foundation.dart';

import 'dto/song_dto.dart';

class ListItem {
  Map<String, dynamic> id3Tags;
  Uint8List bytes;
  late SongDTO song;
  int index;

  ListItem({
    required this.id3Tags,
    required originalTitle,
    required this.bytes,
    required this.index,
  }) {
    String artist, title, album;
    if (id3Tags['Artist'] != null) {
      artist = id3Tags['Artist'];
    } else {
      artist = originalTitle.split(' – ').first;
    }
    if (id3Tags['Title'] != null) {
      title = id3Tags['Title'];
    } else {
      title = originalTitle.split(' – ').last;
    }
    if (id3Tags['Album'] != null) {
      album = id3Tags['Album'];
    } else {
      album = "";
    }
    song = SongDTO(artists: [artist], title: title, album: album);
  }
}