import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/song.dart';

class CloudFirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> addSong(SongDTO dto) async {
    DocumentReference ref = firestore
        .collection("songs")
        .withConverter(
            fromFirestore: Song.fromFirestore,
            toFirestore: (song, options) => song.toFirestore())
        .doc();

    final song = Song(
      title: dto.title,
      artists: dto.artists,
      album: dto.album,
      path: 'songs/${ref.id}.mp3',
      favorite: false,
      feat: dto.feat,
      playlists: [],
    );

    await ref.set(song);
    return ref.id;
  }

  Future<List<Song>> fetchAllSongs() async {
    List<Song> allSongs = [];
    final ref = firestore.collection("songs").withConverter(
        fromFirestore: Song.fromFirestore,
        toFirestore: (song, options) => song.toFirestore());

    QuerySnapshot<Song> querySnapshot = await ref.orderBy('artists').get();
    for (QueryDocumentSnapshot<Song> song in querySnapshot.docs) {
      allSongs.add(song.data());
    }

    allSongs.sort((Song a, Song b) => a.artists!.first
        .toLowerCase()
        .compareTo(b.artists!.first.toLowerCase()));
    return allSongs;
  }
}
