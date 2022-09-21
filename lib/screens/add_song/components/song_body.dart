import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SongBody extends StatelessWidget {
  const SongBody({Key? key}) : super(key: key);

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.audio,
        dialogTitle: 'Wähle Lieder aus');

    if (result == null) return;

    for (PlatformFile file in result.files) {
      if (kDebugMode) {
        print(file.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
          child: const Text('Importiere Lieder aus dem Dateisystem'),
          onPressed: () {
            pickFile();
          },
        ),
      ),
    );
  }
}
