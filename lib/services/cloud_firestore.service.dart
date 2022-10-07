import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selfradio/entities/song.dart';

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
}
