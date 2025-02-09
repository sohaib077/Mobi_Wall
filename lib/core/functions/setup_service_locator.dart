import 'package:get_it/get_it.dart';
import 'package:mobi_wall/core/services/firebase_services.dart';
import 'package:mobi_wall/features/auth/data/repos/auth_repo.dart';
import 'package:mobi_wall/features/auth/data/repos/auth_repo_impl.dart';
import 'package:mobi_wall/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobi_wall/features/children/data/repos/child_apps_repo.dart';
import 'package:mobi_wall/features/children/data/repos/child_apps_repo_impl.dart';
import 'package:mobi_wall/features/children/data/repos/child_repo.dart';
import 'package:mobi_wall/features/children/data/repos/child_repo_impl.dart';
import 'package:mobi_wall/features/children/presentation/manager/child_apps_cubit/child_apps_cubit.dart';
import 'package:mobi_wall/features/children/presentation/manager/children_cubit/children_cubit.dart';
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

  /// Child
  sl.registerLazySingleton<ChildRepo>(() => ChildRepoImpl(sl()));
  sl.registerLazySingleton(() => ChildrenCubit(sl()));

  /// Child Apps
  sl.registerLazySingleton<ChildAppsRepo>(() => ChildAppsRepoImpl(sl()));
  sl.registerLazySingleton(() => ChildAppsCubit(sl()));
}
