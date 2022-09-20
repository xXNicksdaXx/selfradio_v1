import 'dart:core';

import 'package:selfradio/entities/song.dart';

class Playlist {
  final String id;
  final String name;
  final String description;
  final List<Song> songs;
  final String coverPath;

  const Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.songs,
    required this.coverPath,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
        id: json['_id'],
        name: json['name'],
        description: json['description'],
        songs: json['songs'],
        coverPath: json['coverPath']);
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'description': description,
        'songs': songs,
        'coverPath': coverPath,
      };
}
