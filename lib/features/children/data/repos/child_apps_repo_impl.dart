// ignore_for_file: curly_braces_in_flow_control_structures

import '../models/location_data_model.dart';
import 'child_apps_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:mobi_wall/core/errors/error_handler.dart';
import 'package:mobi_wall/core/errors/error_model.dart';
import 'package:mobi_wall/core/services/firebase_services.dart';

class ChildAppsRepoImpl implements ChildAppsRepo {
  final FirebaseService _fb;

  ChildAppsRepoImpl(this._fb);

  @override
  Future<Either<ErrorModel, void>> uploadAppsData(
      {required List<Map<String, dynamic>> apps}) async {
    try {
      await _fb.refreshAppsData(apps: apps);
      return const Right(null);
    } on Exception catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ErrorModel, void>> uploadLocationData(
      {required LocationDataModel location}) async {
    try {
      await _fb.refreshLocationData(location: location);
      return const Right(null);
    } on Exception catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
