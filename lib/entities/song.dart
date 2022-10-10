import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String? title;
  final List<String>? artists;
  final String? album;
  final String? path;
  final bool? favorite;
  final List<String>? feat;
  final List<String>? playlists;

  Song(
      {this.title,
      this.artists,
      this.album,
      this.path,
      this.favorite,
      this.feat,
      this.playlists});

  factory Song.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Song(
      title: data?['title'],
      artists:
          data?['artists'] is Iterable ? List.from(data?['artists']) : null,
      album: data?['album'],
      path: data?['path'],
      favorite: data?['favorite'],
      feat: data?['feat'] is Iterable ? List.from(data?['feat']) : null,
      playlists:
          data?['playlists'] is Iterable ? List.from(data?['playlists']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "title": title,
      if (artists != null) "artists": artists,
      if (album != null) "album": album,
      if (path != null) "path": path,
      if (favorite != null) "favorite": favorite,
      if (feat != null) "feat": feat,
      if (playlists != null) "playlists": playlists,
    };
  }
}