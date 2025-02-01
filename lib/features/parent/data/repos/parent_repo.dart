import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_model.dart';
import '../models/child_data_model.dart';

abstract class ParentRepo {
  Future<Either<ErrorModel, void>> addChild({required ChildDataModel childData});
  Future<Either<ErrorModel, List<ChildDataModel>>> getChildren();
  Future<Either<ErrorModel, void>> deleteChild({required String username});
}
