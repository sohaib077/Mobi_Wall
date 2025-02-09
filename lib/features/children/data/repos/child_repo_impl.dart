// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';

import 'child_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:mobi_wall/core/errors/error_handler.dart';
import 'package:mobi_wall/core/errors/error_model.dart';
import 'package:mobi_wall/core/services/firebase_services.dart';

class ChildRepoImpl implements ChildRepo {
  final FirebaseService _fb;

  ChildRepoImpl(this._fb);

  @override
  Future<Either<ErrorModel, ChildDataModel>> childLogin(
      {required String username, required String password}) async {
    try {
      final bool childExists = await _fb.checkIfChildExists(username: username);
      if (!childExists)
        return left(ErrorModel(message: "Can't find this child"));

      final result = await _fb.loginChild(username: username);
      ChildDataModel childData = ChildDataModel.fromJson(result.data()!);

      if (childData.password != password)
        return left(ErrorModel(message: 'Wrong password'));

      return right(childData);
    } on Exception catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
