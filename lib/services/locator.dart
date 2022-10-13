import 'package:get_it/get_it.dart';

import 'audio_player_service.dart';
import 'cloud_firestore_service.dart';
import 'firebase_storage_service.dart';

final GetIt getIt = GetIt.instance;

setup() async {
  getIt.registerSingleton<FirebaseStorageService>(FirebaseStorageService());
  getIt.registerSingleton<CloudFirestoreService>(CloudFirestoreService());
  getIt.registerSingleton<AudioPlayerService>(AudioPlayerService());
}
