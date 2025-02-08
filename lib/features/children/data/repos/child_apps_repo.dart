import 'package:dartz/dartz.dart';
import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';
import '../../../../core/errors/error_model.dart';
import '../models/location_data_model.dart';

abstract class ChildAppsRepo {
  Future<Either<ErrorModel, void>> uploadAppsData(
      {required List<Map<String, dynamic>> apps});

  Future<Either<ErrorModel, void>> uploadLocationData(
      {required LocationDataModel location});
}
