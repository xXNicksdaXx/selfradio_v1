import 'package:flutter/material.dart';
import 'package:selfradio/constants.dart';
import 'package:selfradio/entities/list_item.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget(
      {Key? key, required this.item, required this.animation, this.onClicked})
      : super(key: key);

  final ListItem item;
  final Animation<double> animation;
  final VoidCallback? onClicked;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      key: ValueKey(item.headerValue),
      sizeFactor: animation,
      child: Container(
          margin: const EdgeInsets.all(kDefaultPadding * 0.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kDefaultSmallRadius),
            color: kAltBackgroundColor,
          ),
          child: Column(
            children: [
              ListTile(
                title: Text(item.song.artist),
                subtitle: const Text(
                  "~ Interpret",
                  style: TextStyle(color: kTextColor),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.upload,
                    color: Colors.white,
                  ),
                  tooltip: 'Hochladen',
                  onPressed: onClicked,
                ),
              ),
              ListTile(
                title: Text(item.song.title),
                subtitle: const Text(
                  "~ Titel",
                  style: TextStyle(color: kTextColor),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  tooltip: 'Bearbeiten',
                  onPressed: () {
                    // route to editing
                  },
                ),
              ),
            ],
          )),
    );
  }
}
