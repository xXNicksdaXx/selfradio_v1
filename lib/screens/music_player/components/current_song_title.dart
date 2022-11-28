import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../services/locator.dart';
import '../../../services/page_manager.dart';

class CurrentSongTitle extends StatelessWidget {
  const CurrentSongTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return Column(
      children: [
        ValueListenableBuilder<String>(
          valueListenable: pageManager.currentSongTitleNotifier,
          builder: (_, title, __) {
            return Padding(
              padding: const EdgeInsets.only(top: kDefaultPadding),
              child: Text(title, style: const TextStyle(fontSize: 24)),
            );
          },
        ),
        ValueListenableBuilder<String>(
          valueListenable: pageManager.currentSongArtistNotifier,
          builder: (_, artist, __) {
            return Padding(
              padding: const EdgeInsets.only(
                  top: kDefaultPadding * 0.5, bottom: kDefaultPadding),
              child: Text(artist, style: const TextStyle(fontSize: 16)),
            );
          },
        ),
      ],
    );
  }
}
