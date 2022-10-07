import 'package:get_it/get_it.dart';
import 'package:selfradio/services/cloud_firestore.service.dart';

import 'firebase_storage.service.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<FirebaseStorageService>(FirebaseStorageService());
  getIt.registerSingleton<CloudFirestoreService>(CloudFirestoreService());
}
