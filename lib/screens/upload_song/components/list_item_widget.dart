import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selfradio/entities/list_item.dart';
import 'package:selfradio/provider/upload_list_state.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../constants.dart';
import '../../../entities/dto/song_dto.dart';
import '../../../entities/enum/upload_state.dart';
import '../edit_song_screen.dart';

class ListItemWidget extends ConsumerWidget {
  const ListItemWidget({Key? key, required this.item, required this.onClicked})
      : super(key: key);

  final ListItem item;
  final VoidCallback? onClicked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        margin: const EdgeInsets.all(kDefaultPadding * 0.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kDefaultSmallRadius),
          color: kAltBackgroundColor,
        ),
        child: ListTile(
          title: Padding(
              padding: const EdgeInsets.only(top: kDefaultPadding * 0.25),
              child: TextScroll(
                item.song.title,
                velocity: const Velocity(pixelsPerSecond: Offset(32, 0)),
                delayBefore: const Duration(milliseconds: 2000),
              )),
          subtitle: Padding(
            padding: const EdgeInsets.all(kDefaultPadding * 0.25),
            child: TextScroll(
              "~ ${item.song.artists.join(', ')}",
              style: const TextStyle(color: Colors.white70),
              velocity: const Velocity(pixelsPerSecond: Offset(32, 0)),
              delayBefore: const Duration(milliseconds: 2000),
            ),
          ),
          trailing: buildTrailingIcons(context, ref),
        ));
  }

  Widget buildTrailingIcons(BuildContext context, WidgetRef ref) {
    UploadState uploadState = ref
        .watch(uploadListState)
        .where((element) => element.id == item.id)
        .first
        .uploadState;
    switch (uploadState) {
      case UploadState.notStarted:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: kTextColor,
                ),
                tooltip: 'Bearbeiten',
                onPressed: () async {
                  var result =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditScreen(
                                context: context,
                                song: item.song,
                              )));
                  if (result is SongDTO) {
                    ref
                        .watch(uploadListState.notifier)
                        .setListItem(item.id, item.setSongDTO(result));
                  }
                }),
            IconButton(
              icon: const Icon(
                Icons.upload,
                color: kTextColor,
              ),
              tooltip: 'Hochladen',
              onPressed: onClicked,
            ),
          ],
        );
      case UploadState.running:
        return Transform.scale(
          scale: 0.8,
          child: const CircularProgressIndicator(
            color: kSecondaryColor,
          ),
        );
      case UploadState.successful:
        return const Icon(
          Icons.done,
          color: kPrimaryColor,
        );
      case UploadState.error:
        return const Icon(
          Icons.error_outline,
          color: kSecondaryColor,
        );
    }
  }

  getItem(WidgetRef ref) {
    return ref.read(uploadListState);
  }
}
