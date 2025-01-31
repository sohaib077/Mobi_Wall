import 'package:dartz/dartz.dart';
import 'package:mobi_wall/features/auth/data/models/user_data_model.dart';
import '../../../../core/errors/error_model.dart';

abstract class AuthRepo {
  Future<Either<ErrorModel, UserDataModel>> login(
      {required String email, required String password});

  Future<Either<ErrorModel, UserDataModel>> register(
      {required UserDataModel userData});
}
