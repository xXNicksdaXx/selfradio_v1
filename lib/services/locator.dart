import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';

import 'audio_handler_service.dart';
import 'cloud_firestore_service.dart';
import 'firebase_storage_service.dart';
import 'page_manager.dart';

final GetIt getIt = GetIt.instance;

setupGetIt() async {
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerLazySingleton<CloudFirestoreService>(
      () => CloudFirestoreService());
  getIt.registerLazySingleton<FirebaseStorageService>(
      () => FirebaseStorageService());
  getIt.registerLazySingleton<PageManager>(() => PageManager());
}
