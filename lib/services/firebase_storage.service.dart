import 'dart:core';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  void uploadFileViaBytes(String name, Uint8List data) async {
    try {
      await storage.ref().child(name).putData(
          data,
          SettableMetadata(
            contentType: 'audio/mpeg',
          ));
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void uploadFileViaPath(String name, String path) async {
    final file = File(path);

    try {
      storage
          .ref()
          .child(name)
          .putFile(
              file,
              SettableMetadata(
                contentType: 'audio/mpeg',
              ))
          .snapshotEvents
          .listen((event) {
        switch (event.state) {
          case TaskState.running:
            break;
          case TaskState.success:
            break;
          case TaskState.error:
            break;
          case TaskState.paused:
            break;
          case TaskState.canceled:
            break;
        }
      });
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
