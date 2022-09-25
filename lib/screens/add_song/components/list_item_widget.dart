import 'package:flutter/material.dart';
import 'package:selfradio/constants.dart';
import 'package:selfradio/entities/list_item.dart';
import 'package:selfradio/screens/add_song/components/edit_screen.dart';

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
  late MetadataItem newSong;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      key: ValueKey(widget.item.headerValue),
      sizeFactor: widget.animation,
      child: Container(
          margin: const EdgeInsets.all(kDefaultPadding * 0.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kDefaultSmallRadius),
            color: kAltBackgroundColor,
          ),
          child: ListTile(
            title: Text(widget.item.song.title),
            subtitle: Text(
              "~ ${widget.item.song.artist}",
              style: const TextStyle(color: Colors.white70),
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
                        if (result is MetadataItem) {
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
