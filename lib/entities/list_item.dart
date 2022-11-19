import 'dart:core';

import 'package:flutter/foundation.dart';

import 'dto/song_dto.dart';
import 'enum/upload_state.dart';

class ListItem {
  String id;
  Map<String, dynamic> id3Tags;
  Uint8List bytes;
  late SongDTO song;
  UploadState uploadState;

  ListItem({
    required this.id,
    required this.id3Tags,
    required this.bytes,
    String? originalTitle,
    this.uploadState = UploadState.notStarted,
  }) {
    String artist, title, album;
    if (id3Tags['Artist'] != null) {
      artist = id3Tags['Artist'];
    } else if (originalTitle != null) {
      artist = originalTitle.split(' – ').first;
    } else {
      artist = "";
    }
    if (id3Tags['Title'] != null) {
      title = id3Tags['Title'];
    } else if (originalTitle != null) {
      title = originalTitle.split(' – ').last;
    } else {
      title = "";
    }
    if (id3Tags['Album'] != null) {
      album = id3Tags['Album'];
    } else {
      album = "";
    }
    song = SongDTO(artists: [artist], title: title, album: album);
  }

  ListItem setSongDTO(SongDTO song) {
    this.song = song;
    return this;
  }

  ListItem setUploadState(UploadState uploadState) {
    this.uploadState = uploadState;
    return this;
  }
}
