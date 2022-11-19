import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:id3/id3.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../entities/dto/song_dto.dart';
import '../../../entities/enum/upload_state.dart';
import '../../../entities/list_item.dart';
import '../../../provider/upload_list_provider.dart';
import '../../../services/cloud_firestore_service.dart';
import '../../../services/firebase_storage_service.dart';
import '../../../services/locator.dart';
import 'list_item_widget.dart';

class UploadList extends StatefulWidget {
  const UploadList({Key? key}) : super(key: key);

  @override
  State<UploadList> createState() => _UploadListState();
}

class _UploadListState extends State<UploadList> {
  List<ListItem> listItems = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildList(context),
        buildFloatingActionButton(context),
      ],
    );
  }

  Widget buildList(BuildContext context) {
    return ListView.builder(
        itemCount: listItems.length,
        itemBuilder: (context, index) => ListItemWidget(
              item: listItems[index],
              onClicked: () => _removeItem(index),
            ));
  }

  Widget buildFloatingActionButton(BuildContext context) {
    final emptyList = listItems.isEmpty;

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

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.audio);
    if (result == null) return;

    int i = 0;
    for (PlatformFile file in result.files) {
      setState(() {
        listItems.add(_createListItem(file, i));
      });
      Provider.of<UploadListProvider>(context, listen: false).createEntry(i);
      i++;
    }
  }

  ListItem _createListItem(PlatformFile file, int i) {
    Uint8List bytes;

    if (file.bytes != null) {
      bytes = file.bytes!;
    } else {
      String path = file.path!;
      if (Platform.isAndroid) {
        path = path.replaceFirst(
            RegExp(r'/Android/data/de.nicksda.selfradio/files'), '');
      }
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
          index: i);
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
        index: i,
      );
    }
    return item;
  }

  Future<void> _removeItem(int index) async {
    final ListItem itemToUpload = listItems[index];

    String id = await _addToFirestore(itemToUpload.song);
    UploadTask task = await _uploadFileToStorage('$id.mp3', itemToUpload.bytes);
    Provider.of<UploadListProvider>(context, listen: false)
        .updateUploadState(index, UploadState.running);

    task.snapshotEvents.listen((event) async {
      if (event.state == TaskState.success) {
        // change icon
        Provider.of<UploadListProvider>(context, listen: false)
            .updateUploadState(index, UploadState.successful);

        // remove item from list
        setState(() {
          listItems.removeAt(index);
        });
        return;
      } else if (event.state == TaskState.running) {
        UploadState uploadState =
            Provider.of<UploadListProvider>(context, listen: false)
                .getUploadState(index);
        if (uploadState != UploadState.running) {
          Provider.of<UploadListProvider>(context, listen: false)
              .updateUploadState(index, UploadState.running);
        }
      } else {
        UploadState uploadState =
            Provider.of<UploadListProvider>(context, listen: false)
                .getUploadState(index);
        if (uploadState != UploadState.error) {
          Provider.of<UploadListProvider>(context, listen: false)
              .updateUploadState(index, UploadState.error);
        }
      }
    });
  }

  Future<String> _addToFirestore(SongDTO dto) async {
    return getIt<CloudFirestoreService>().addSong(dto);
  }

  Future<UploadTask> _uploadFileToStorage(String name, Uint8List bytes) async {
    return await getIt<FirebaseStorageService>()
        .uploadFileViaBytes(name, bytes);
  }

  void _removeAll() async {}
}
