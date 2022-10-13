import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService extends BaseAudioHandler with SeekHandler {
  AudioPlayer player = AudioPlayer();

  AudioPlayerService() {
    playbackState.add(playbackState.value.copyWith(
        controls: [MediaControl.play],
        processingState: AudioProcessingState.loading));
    player
        .setAudioSource(AudioSource.uri(Uri.parse(
            "https://firebasestorage.googleapis.com/v0/b/selfradio-f2820.appspot.com/o/songs%2F7PtLIIJ8PAWnCqKJB6ip.mp3?alt=media&token=aef38918-5000-499d-bec0-64dd38499d0b")))
        .then((_) {
      playbackState.add(playbackState.value
          .copyWith(processingState: AudioProcessingState.ready));
    });
  }

  @override
  Future<void> play() async {
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [MediaControl.pause],
    ));
    await player.play();
  }

  @override
  Future<void> pause() async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [MediaControl.play],
    ));
    await player.pause();
  }

  @override
  Future<void> stop() async {
    playbackState.add(playbackState.value.copyWith(
        playing: false,
        controls: [MediaControl.play],
        processingState: AudioProcessingState.idle));
    await player.stop();
  }
}
