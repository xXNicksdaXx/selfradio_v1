import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'song.dart';

class Playlist {
  final String? name;
  final String? description;
  final List<Song>? songs;
  final String? coverPath;

  Playlist({
    this.name,
    this.description,
    this.songs,
    this.coverPath,
  });

  factory Playlist.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Playlist(
      name: data?['name'],
      description: data?['description'],
      songs: data?['songs'] is Iterable ? List.from(data?['songs']) : null,
      coverPath: data?['coverPath'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (songs != null) "songs": songs,
      if (coverPath != null) "coverPath": coverPath,
    };
  }
}
