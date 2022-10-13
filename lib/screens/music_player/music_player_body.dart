import 'package:flutter/material.dart';
import 'package:selfradio/services/locator.dart';
import 'package:selfradio/services/page_manager.dart';

import 'components/audio_control_buttons.dart';
import 'components/audio_progress_bar.dart';
import 'components/current_song_title.dart';
import 'components/playlist_widget.dart';

class MusicPlayerBody extends StatefulWidget {
  const MusicPlayerBody({Key? key}) : super(key: key);

  @override
  State<MusicPlayerBody> createState() => _MusicPlayerBodyState();
}

class _MusicPlayerBodyState extends State<MusicPlayerBody> {
  @override
  void initState() {
    super.initState();
    getIt<PageManager>().init();
  }

  @override
  void dispose() {
    getIt<PageManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: const [
          CurrentSongTitle(),
          PlaylistWidget(),
          AudioProgressBar(),
          AudioControlButtons(),
        ],
      ),
    );
  }
}
