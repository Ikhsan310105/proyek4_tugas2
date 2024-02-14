import 'package:get_it/get_it.dart';
import 'package:tugas2/services/local_storage.dart';
import 'package:tugas2/services/web_api.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<WebApi>(() => FccApi());
  getIt.registerLazySingleton<LocalStorage>(() => SharedPrefsStorage());
}
