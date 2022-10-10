import 'dart:core';

class SongDTO {
  List<String> artists;
  String title;
  String album;
  List<String>? feat;

  SongDTO({
    required this.artists,
    required this.title,
    required this.album,
    this.feat,
  });
}
