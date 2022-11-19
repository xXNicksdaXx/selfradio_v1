import 'package:flutter/material.dart';

import '../entities/enum/upload_state.dart';

class UploadListProvider extends ChangeNotifier {
  Map<int, UploadState> uploadMap = {};

  void createEntry(int index) {
    uploadMap[index] = UploadState.notStarted;
  }

  void updateUploadState(int index, UploadState state) {
    uploadMap[index] = state;
    notifyListeners();
  }

  UploadState getUploadState(int index) {
    if (uploadMap.containsKey(index)) {
      return uploadMap[index]!;
    } else {
      return UploadState.error;
    }
  }
}
