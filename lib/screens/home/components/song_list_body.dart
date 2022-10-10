import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../entities/song.dart';
import '../../../services/cloud_firestore.service.dart';
import '../../../services/locator.dart';

class SongListBody extends StatefulWidget {
  const SongListBody({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SongListBodyState();
  }
}

class SongListBodyState extends State<SongListBody> {
  late Future<List<Song>> songs;

  @override
  void initState() {
    super.initState();

    songs = getIt<CloudFirestoreService>().fetchAllSongs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Song>>(
        future: songs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: ListTile(
                    leading: const Icon(
                      Icons.audiotrack,
                    ),
                    title: Text(snapshot.data![index].title!),
                    subtitle: Text(
                      snapshot.data![index].artists!.join(", "),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: buildPopupOptions(),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget buildPopupOptions() {
    return PopupMenuButton(
      color: kAltBackgroundColor,
      icon: const Icon(
        Icons.more_vert,
        color: kTextColor,
      ),
      iconSize: 16,
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: 1,
          child: Text("Abspielen"),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text("Zur Warteschlange hinzufügen"),
        )
      ],
      tooltip: "",
    );
  }
}
