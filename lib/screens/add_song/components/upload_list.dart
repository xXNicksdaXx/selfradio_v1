import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:id3/id3.dart';
import 'package:selfradio/constants.dart';
import 'package:selfradio/entities/list_item.dart';
import 'package:selfradio/screens/add_song/components/list_item_widget.dart';
import 'package:selfradio/services/firebase_storage.service.dart';
import 'package:selfradio/services/locator.dart';

class UploadList extends StatefulWidget {
  const UploadList({Key? key}) : super(key: key);

  @override
  State<UploadList> createState() => _UploadListState();
}

class _UploadListState extends State<UploadList> {
  final listKey = GlobalKey<AnimatedListState>();
  List<ListItem> songsToUpload = [];
  bool emptyList = true;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.audio);
    if (result == null) return;

    for (PlatformFile file in result.files) {
      final item = _createListItem(file);
      _insertItem(item);
    }
  }

  ListItem _createListItem(PlatformFile file) {
    Uint8List bytes;

    if (file.bytes != null) {
      bytes = file.bytes!;
    } else {
      String path = _correctPath(file.path!);
      bytes = File(path).readAsBytesSync();
    }
    MP3Instance mp3instance = MP3Instance(bytes);

    ListItem item;

    bool metaTagsAvailable;

    try {
      metaTagsAvailable = mp3instance.parseTagsSync();
    } catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
      metaTagsAvailable = false;
    }

    if (metaTagsAvailable) {
      item = ListItem(
        headerValue: file.name,
        id3Tags: mp3instance.getMetaTags()!,
        bytes: bytes,
      );
    } else {
      final splitFileName = file.name.split(' – ');
      item = ListItem(
        headerValue: file.name,
        id3Tags: {
          'Artist': splitFileName.first,
          'Title': splitFileName.last.substring(0, splitFileName[1].length - 4),
          'Album': ""
        },
        bytes: bytes,
      );
    }
    return item;
  }

  void _insertItem(ListItem newItem) {
    const newIndex = 0;

    songsToUpload.insert(newIndex, newItem);
    if (emptyList) {
      setState(() {
        emptyList = false;
      });
    }
    listKey.currentState!
        .insertItem(newIndex, duration: const Duration(milliseconds: 500));
  }

  void _removeItem(int index) async {
    final ListItem uploadedItem = songsToUpload[index];

    _uploadFile(uploadedItem.headerValue, uploadedItem.bytes);

    songsToUpload.removeAt(index);
    if (songsToUpload.isEmpty) {
      setState(() {
        emptyList = true;
      });
    }
    listKey.currentState!.removeItem(
        index,
        (context, animation) => ListItemWidget(
              item: uploadedItem,
              animation: animation,
              onClicked: () {},
            ),
        duration: const Duration(milliseconds: 500));
  }

  void _removeAll() async {
    while (!emptyList) {
      _removeItem(0);
    }
  }

  void _uploadFile(String name, Uint8List bytes) async {
    getIt<FirebaseStorageService>().uploadFileViaBytes(name, bytes);
  }

  String _correctPath(String oldPath) {
    String newPath = oldPath;
    if (Platform.isAndroid) {
      newPath = oldPath.replaceFirst(
          RegExp(r'/Android/data/de.nicksda.selfradio/files'), '');
    }
    return newPath;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildList(),
        buildFloatingActionButton(),
      ],
    );
  }

  Widget buildList() {
    return AnimatedList(
        key: listKey,
        initialItemCount: songsToUpload.length,
        itemBuilder: (context, index, animation) => ListItemWidget(
              item: songsToUpload[index],
              animation: animation,
              onClicked: () => _removeItem(index),
            ));
  }

  Widget buildFloatingActionButton() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          backgroundColor: kSecondaryColor,
          onPressed: () {
            emptyList ? _pickFile() : _removeAll();
          },
          tooltip: emptyList ? 'Importiere Dateien' : 'Alles hochladen',
          child: emptyList
              ? const Icon(Icons.file_open)
              : const Icon(Icons.upload),
        ),
      ),
    );
  }
}
