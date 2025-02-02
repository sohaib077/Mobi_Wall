import 'package:get_it/get_it.dart';
import 'package:mobi_wall/core/services/firebase_services.dart';
import 'package:mobi_wall/features/auth/data/repos/auth_repo.dart';
import 'package:mobi_wall/features/auth/data/repos/auth_repo_impl.dart';
import 'package:mobi_wall/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobi_wall/features/parent/data/repos/parent_repo.dart';
import 'package:mobi_wall/features/parent/data/repos/parent_repo_impl.dart';
import 'package:mobi_wall/features/parent/presentation/manager/parent_cubit.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  /// Services
  sl.registerLazySingleton(() => FirebaseService());

  /// Auth
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));
  sl.registerLazySingleton(() => AuthCubit(sl()));

  /// Parent
  sl.registerLazySingleton<ParentRepo>(() => ParentRepoImpl(sl()));
  sl.registerLazySingleton(() => ParentCubit(sl()));
}
