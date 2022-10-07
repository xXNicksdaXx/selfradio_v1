import 'package:flutter/material.dart';
import 'package:selfradio/constants.dart';
import 'package:selfradio/entities/list_item.dart';
import 'package:selfradio/screens/add_song/components/edit_screen.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../entities/song.dart';

class ListItemWidget extends StatefulWidget {
  ListItemWidget(
      {Key? key, required this.item, required this.animation, this.onClicked})
      : super(key: key);

  ListItem item;
  final Animation<double> animation;
  final VoidCallback? onClicked;

  @override
  State<ListItemWidget> createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.animation,
      child: Container(
          margin: const EdgeInsets.all(kDefaultPadding * 0.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kDefaultSmallRadius),
            color: kAltBackgroundColor,
          ),
          child: ListTile(
            title: Padding(
                padding: const EdgeInsets.only(top: kDefaultPadding * 0.25),
                child: TextScroll(
                  widget.item.song.title,
                  velocity: const Velocity(pixelsPerSecond: Offset(32, 0)),
                  delayBefore: const Duration(milliseconds: 2000),
                )),
            subtitle: Padding(
              padding: const EdgeInsets.all(kDefaultPadding * 0.25),
              child: TextScroll(
                "~ ${widget.item.song.artists.join(', ')}",
                style: const TextStyle(color: Colors.white70),
                velocity: const Velocity(pixelsPerSecond: Offset(32, 0)),
                delayBefore: const Duration(milliseconds: 2000),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    tooltip: 'Bearbeiten',
                    onPressed: () async {
                      var result =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditScreen(
                                    context: context,
                                    song: widget.item.song,
                                  )));
                      setState(() {
                        if (result is SongDTO) {
                          widget.item.song = result;
                        }
                      });
                    }),
                IconButton(
                  icon: const Icon(
                    Icons.upload,
                    color: Colors.white,
                  ),
                  tooltip: 'Hochladen',
                  onPressed: widget.onClicked,
                ),
              ],
            ),
          )),
    );
  }
}
