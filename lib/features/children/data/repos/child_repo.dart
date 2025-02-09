import 'package:dartz/dartz.dart';
import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';
import '../../../../core/errors/error_model.dart';

abstract class ChildRepo {
  Future<Either<ErrorModel, ChildDataModel>> childLogin({required String username,required String password});
}
