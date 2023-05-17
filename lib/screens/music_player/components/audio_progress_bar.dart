import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../notifiers/progress_notifier.dart';
import '../../../services/locator.dart';
import '../../../services/page_manager.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: pageManager.seek,
          thumbColor: kPrimaryColor,
          baseBarColor: kPrimaryColor.withOpacity(0.5),
          bufferedBarColor: const Color(0x00000000),
          progressBarColor: kPrimaryColor.withOpacity(0.8),
        );
      },
    );
  }
}
