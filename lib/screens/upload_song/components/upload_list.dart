import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:id3/id3.dart';

import '../../../constants.dart';
import '../../../entities/list_item.dart';
import '../../../entities/song.dart';
import '../../../services/cloud_firestore.service.dart';
import '../../../services/firebase_storage.service.dart';
import '../../../services/locator.dart';
import 'list_item_widget.dart';

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
        originalTitle: file.name,
        id3Tags: mp3instance.getMetaTags()!,
        bytes: bytes,
      );
    } else {
      final splitFileName = file.name.split(' – ');
      item = ListItem(
        originalTitle: file.name,
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
    final ListItem itemToUpload = songsToUpload[index];
    songsToUpload.removeAt(index);

    String id = await _addToFirestore(itemToUpload.song);
    _uploadFile('$id.mp3', itemToUpload.bytes);

    if (songsToUpload.isEmpty) {
      setState(() {
        emptyList = true;
      });
    }
    listKey.currentState!.removeItem(
        index,
        (context, animation) => ListItemWidget(
              item: itemToUpload,
              animation: animation,
              onClicked: () {},
            ),
        duration: const Duration(milliseconds: 500));
  }

  void _removeAll() async {
    while (songsToUpload.isNotEmpty) {
      _removeItem(0);
      await Future.delayed(const Duration(milliseconds: 850));
    }
  }

  Future<String> _addToFirestore(SongDTO dto) async {
    return getIt<CloudFirestoreService>().addSong(dto);
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
