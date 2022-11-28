import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/list_item.dart';

class UploadListState extends StateNotifier<List<ListItem>> {
  UploadListState() : super(const []);

  void addItem(ListItem item) => state = [...state, item];

  List<ListItem> getAll() => state;

  void removeItem(String uuid) {
    state = [
      for (final item in state)
        if (item.id != uuid) item,
    ];
  }

  ListItem? getItem(String uuid) {
    for (ListItem item in state) {
      if (item.id == uuid) return item;
    }
    return null;
  }

  void setListItem(String uuid, ListItem newItem) {
    state = state.map((item) {
      return uuid == item.id ? newItem : item;
    }).toList();
  }
}

final uploadListState =
    StateNotifierProvider<UploadListState, List<ListItem>>((ref) {
  return UploadListState();
});
