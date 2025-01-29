import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  /// Services
  // sl.registerLazySingleton(() => FirebaseService());

  /// Home
  // sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl()));
  // sl.registerLazySingleton(() => HomeCubit());
}
