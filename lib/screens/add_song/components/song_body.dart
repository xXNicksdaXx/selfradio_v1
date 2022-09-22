import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:selfradio/constants.dart';
import 'package:selfradio/services/firebase_storage.service.dart';
import 'package:selfradio/services/locator.dart';

class SongBody extends StatefulWidget {
  const SongBody({Key? key}) : super(key: key);

  @override
  State<SongBody> createState() => _SongBodyState();
}

class _SongBodyState extends State<SongBody> {
  List<Item> songsToUpload = [];

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.audio);

    if (result == null) return;

    for (PlatformFile file in result.files) {
      setState(() {
        songsToUpload.add(Item(
          expandedValue: '${file.path!}, ${file.size}',
          headerValue: file.name,
          file: file,
        ));
      });
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSecondaryColor,
                    foregroundColor: kTextColor,
                  ),
                  onPressed: () {
                    _pickFile();
                  },
                  child: const Icon(Icons.file_open),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSecondaryColor,
                    foregroundColor: kTextColor,
                    disabledBackgroundColor: Colors.white38,
                    disabledForegroundColor: kAltTextColor,
                  ),
                  onPressed: () {
                    if (songsToUpload.isNotEmpty) {
                    } else {
                      null;
                    }
                  },
                  child: const Icon(Icons.upload_file),
                ),
              ],
            ),
          ),
          buildPanel(),
        ],
      ),
    );
  }

  Widget buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          songsToUpload[index].isExpanded = !isExpanded;
        });
      },
      children: songsToUpload.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          backgroundColor: kBackgroundColor,
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
              title: Text(item.expandedValue),
              trailing: const Icon(Icons.upload, color: kTextColor),
              onTap: () {
                _uploadFile(item.file);
                setState(() {
                  songsToUpload
                      .removeWhere((Item currentItem) => item == currentItem);
                });
              }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    required this.file,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  PlatformFile file;
  bool isExpanded;
}
