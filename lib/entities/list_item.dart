import 'dart:core';

import 'package:file_picker/file_picker.dart';

class ListItem {
  ListItem({
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
