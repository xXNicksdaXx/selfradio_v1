import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../../services/audio_player_service.dart';
import '../../services/locator.dart';

class MusicPlayerBody extends StatelessWidget {
  const MusicPlayerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          StreamBuilder(
            stream: getIt<AudioPlayerService>().playbackState,
            builder: (context, snapshot) {
              final playing = snapshot.data?.playing ?? false;
              final processingState =
                  snapshot.data?.processingState ?? AudioProcessingState.idle;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (playing)
                    ElevatedButton(
                        child: Text("Pause"),
                        onPressed: getIt<AudioPlayerService>().pause)
                  else
                    ElevatedButton(
                        child: Text("Play"),
                        onPressed: getIt<AudioPlayerService>().play),
                ],
              );
            },
          ),
          ElevatedButton(
            child: const Text("Stop"),
            onPressed: () {
              final audioPlayerService = getIt<AudioPlayerService>();
              audioPlayerService.stop();
            },
          ),
        ],
      ),
    );
  }
}
