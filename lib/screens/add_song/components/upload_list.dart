import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
      _insertItem(file);
    }
  }

  void _uploadFile(PlatformFile file) async {
    if (file.bytes != null) {
      getIt<FirebaseStorageService>()
          .uploadFileViaBytes(file.name, file.bytes!);
    } else if (file.path != null) {
      String reducedPath = file.path!.replaceFirst(
          RegExp(r'/Android/data/de.nicksda.selfradio/files'), '');
      getIt<FirebaseStorageService>().uploadFileViaPath(file.name, reducedPath);
    }
  }

  void _uploadAll() async {
    while (!emptyList) {
      _removeItem(0);
    }
  }

  void _insertItem(PlatformFile file) {
    const newIndex = 0;
    final newItem = ListItem(
      headerValue: file.name,
      expandedValue: file.path!,
      file: file,
    );
    songsToUpload.insert(newIndex, newItem);
    if (emptyList) {
      setState(() {
        emptyList = false;
      });
    }
    listKey.currentState!.insertItem(newIndex);
  }

  void _removeItem(int index) async {
    final uploadedItem = songsToUpload[index];

    _uploadFile(uploadedItem.file);

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
            ));
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
            emptyList ? _pickFile() : _uploadAll();
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
