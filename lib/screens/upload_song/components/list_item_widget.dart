import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../constants.dart';
import '../../../entities/dto/song_dto.dart';
import '../../../entities/enum/upload_state.dart';
import '../../../entities/list_item.dart';
import '../../../provider/upload_list_provider.dart';
import '../edit_song_screen.dart';

class ListItemWidget extends StatefulWidget {
  const ListItemWidget({Key? key, required this.item, required this.onClicked})
      : super(key: key);

  final ListItem item;
  final VoidCallback? onClicked;

  @override
  State<ListItemWidget> createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
  late SongDTO song;

  @override
  void initState() {
    super.initState();
    song = widget.item.song;
  }

  @override
  Widget build(BuildContext context) {
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
                song.title,
                velocity: const Velocity(pixelsPerSecond: Offset(32, 0)),
                delayBefore: const Duration(milliseconds: 2000),
              )),
          subtitle: Padding(
            padding: const EdgeInsets.all(kDefaultPadding * 0.25),
            child: TextScroll(
              "~ ${song.artists.join(', ')}",
              style: const TextStyle(color: Colors.white70),
              velocity: const Velocity(pixelsPerSecond: Offset(32, 0)),
              delayBefore: const Duration(milliseconds: 2000),
            ),
          ),
          trailing: buildTrailingIcons(),
        ));
  }

  Widget buildTrailingIcons() {
    UploadState uploadState =
        Provider.of<UploadListProvider>(context, listen: false)
            .getUploadState(widget.item.index);
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
                                song: song,
                              )));
                  setState(() {
                    if (result is SongDTO) {
                      song = result;
                    }
                  });
                }),
            IconButton(
              icon: const Icon(
                Icons.upload,
                color: kTextColor,
              ),
              tooltip: 'Hochladen',
              onPressed: widget.onClicked,
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
}
