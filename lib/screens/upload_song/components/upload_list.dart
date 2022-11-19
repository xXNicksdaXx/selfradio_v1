import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:id3/id3.dart';
import 'package:selfradio/provider/upload_list_state.dart';
import 'package:uuid/uuid.dart';

import '../../../constants.dart';
import '../../../entities/dto/song_dto.dart';
import '../../../entities/enum/upload_state.dart';
import '../../../entities/list_item.dart';
import '../../../services/cloud_firestore_service.dart';
import '../../../services/firebase_storage_service.dart';
import '../../../services/locator.dart';
import 'list_item_widget.dart';

class UploadList extends ConsumerWidget {
  const UploadList({Key? key}) : super(key: key);

  static const uuid = Uuid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        buildList(context, ref),
        buildFloatingActionButton(context, ref),
      ],
    );
  }

  Widget buildList(BuildContext context, WidgetRef ref) {
    final songsToUpload = ref.watch(uploadListState);
    return ListView.builder(
        itemCount: songsToUpload.length,
        itemBuilder: (_, index) => ListItemWidget(
              item: songsToUpload[index],
              onClicked: () => _removeItem(ref, songsToUpload[index].id),
            ));
  }

  Widget buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    final emptyList = ref.watch(uploadListState).isEmpty;

    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          backgroundColor: kSecondaryColor,
          onPressed: () {
            emptyList ? _pickFile(ref) : _removeAll(ref);
          },
          tooltip: emptyList ? 'Importiere Dateien' : 'Alles hochladen',
          child: emptyList
              ? const Icon(Icons.file_open)
              : const Icon(Icons.upload),
        ),
      ),
    );
  }

  void _pickFile(WidgetRef ref) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.audio);
    if (result == null) return;

    for (PlatformFile file in result.files) {
      ref.read(uploadListState.notifier).addItem(_createListItem(file));
    }
  }

  ListItem _createListItem(PlatformFile file) {
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
          id: uuid.v4(),
          originalTitle: file.name,
          id3Tags: mp3instance.getMetaTags()!,
          bytes: bytes);
    } else {
      final splitFileName = file.name.split(' – ');
      item = ListItem(
          id: uuid.v4(),
          originalTitle: file.name,
          id3Tags: {
            'Artist': splitFileName.first,
            'Title':
                splitFileName.last.substring(0, splitFileName[1].length - 4),
            'Album': ""
          },
          bytes: bytes);
    }
    return item;
  }

  Future<void> _removeItem(WidgetRef ref, String uuid) async {
    final itemToUpload = ref.read(uploadListState.notifier).getItem(uuid);
    if (itemToUpload == null) return;

    String id = await _addToFirestore(itemToUpload.song);
    UploadTask task = await _uploadFileToStorage('$id.mp3', itemToUpload.bytes);
    task.snapshotEvents.listen((taskSnapshot) {
      bool running = false;
      switch (taskSnapshot.state) {
        case TaskState.running:
          if (!running) {
            ref.read(uploadListState.notifier).setListItem(
                uuid, itemToUpload.setUploadState(UploadState.running));
            running = true;
          }
          break;
        case TaskState.success:
          ref.read(uploadListState.notifier).setListItem(
              uuid, itemToUpload.setUploadState(UploadState.successful));
          ref.read(uploadListState.notifier).removeItem(uuid);
          return;
        default:
          ref.read(uploadListState.notifier).setListItem(
              uuid, itemToUpload.setUploadState(UploadState.error));
          return;
      }
    });
  }

  void _removeAll(WidgetRef ref) async {
    List<ListItem> itemsToUpload = ref.read(uploadListState.notifier).getAll();

    for (final item in itemsToUpload) {
      String id = await _addToFirestore(item.song);
      UploadTask task = await _uploadFileToStorage('$id.mp3', item.bytes);
      task.snapshotEvents.listen((taskSnapshot) {
        bool running = false;
        switch (taskSnapshot.state) {
          case TaskState.running:
            if (!running) {
              ref.read(uploadListState.notifier).setListItem(
                  item.id, item.setUploadState(UploadState.running));
              running = true;
            }
            break;
          case TaskState.success:
            ref.read(uploadListState.notifier).setListItem(
                item.id, item.setUploadState(UploadState.successful));
            ref.read(uploadListState.notifier).removeItem(item.id);
            return;
          default:
            ref
                .read(uploadListState.notifier)
                .setListItem(item.id, item.setUploadState(UploadState.error));
            return;
        }
      });
    }
  }

  Future<String> _addToFirestore(SongDTO dto) async {
    return getIt<CloudFirestoreService>().addSong(dto);
  }

  Future<UploadTask> _uploadFileToStorage(String name, Uint8List bytes) async {
    return await getIt<FirebaseStorageService>()
        .uploadFileViaBytes(name, bytes);
  }
}
