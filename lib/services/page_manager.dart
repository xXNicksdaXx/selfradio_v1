import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:selfradio/services/locator.dart';

import '../notifiers/play_button_notifier.dart';
import '../notifiers/progress_notifier.dart';
import '../notifiers/repeat_button_notifier.dart';

class PageManager {
  final audioHandler = getIt<AudioHandler>();

  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final currentSongArtistNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  // Events: Calls coming from the UI
  void init() async {
    _loadPlaylist();
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
  }

  void play() {
    audioHandler.play();
  }

  void pause() {
    audioHandler.pause();
  }

  void seek(Duration position) {
    audioHandler.seek(position);
  }

  void previous() {
    audioHandler.skipToPrevious();
  }

  void next() {
    audioHandler.skipToNext();
  }

  void repeat() {
    repeatButtonNotifier.nextState();
    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  void add() {}

  void remove() {}

  void dispose() {
    audioHandler.stop();
  }

  Future<void> _loadPlaylist() async {
    const mediaItems = [
      MediaItem(
        id: 'Kate Bush - Running Up That Hill',
        album: '',
        title: 'Running Up That Hill',
        artist: 'Kate Bush',
        extras: {
          'url':
              'https://firebasestorage.googleapis.com/v0/b/selfradio-f2820.appspot.com/o/songs%2F4JRI4w1CRuZ5FgdwgEO1.mp3?alt=media&token=172e03b5-d52d-4117-93d6-6e352c236774'
        },
      ),
      MediaItem(
        id: 'ABBA - Lay All Your Love On Me',
        album: '',
        title: 'Lay All Your Love On Me',
        artist: 'ABBA',
        extras: {
          'url':
              'https://firebasestorage.googleapis.com/v0/b/selfradio-f2820.appspot.com/o/songs%2FD8031K56VMtmuQ5c0h2R.mp3?alt=media&token=d4449d75-f4ce-42a0-a0cf-135bd2c4a7f0'
        },
      ),
      MediaItem(
        id: 'Belinda Carlisle - Circle In The Sand',
        album: '',
        title: 'Circle In The Sand',
        artist: 'Belinda Carlisle',
        extras: {
          'url':
          'https://firebasestorage.googleapis.com/v0/b/selfradio-f2820.appspot.com/o/songs%2FNTwdZ32gH7Xqfe51GApX.mp3?alt=media&token=78175e38-c5a9-4060-9ec4-d6fd10290e13'
        },
      )

    ];
    audioHandler.addQueueItems(mediaItems);
  }

  void _listenToChangesInPlaylist() {
    audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) return;
      final newList = playlist.map((item) => item.title).toList();
      playlistNotifier.value = newList;
    });
  }

  void _listenToPlaybackState() {
    audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        audioHandler.seek(Duration.zero);
        audioHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void _listenToChangesInSong() {
    audioHandler.mediaItem.listen((mediaItem) {
      currentSongTitleNotifier.value = mediaItem?.title ?? '';
      currentSongArtistNotifier.value = mediaItem?.artist ?? '';
      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = audioHandler.mediaItem.value;
    final playlist = audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = playlist.last == mediaItem;
    }
  }
}
