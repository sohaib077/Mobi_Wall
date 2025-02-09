import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';

import 'parent_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:mobi_wall/core/errors/error_handler.dart';
import 'package:mobi_wall/core/errors/error_model.dart';
import 'package:mobi_wall/core/services/firebase_services.dart';

class ParentRepoImpl implements ParentRepo {
  final FirebaseService _fb;

  ParentRepoImpl(this._fb);

  @override
  Future<Either<ErrorModel, void>> addChild(
      {required ChildDataModel childData}) async {
    try {
      final bool exists = await _fb.checkIfChildExists(username: childData.username);
      if (exists) {
        return left(ErrorModel(
            message: "You've added a child with the same username before."));
      }
      await _fb.setChildData(childData: childData);
      return const Right(null);
    } on Exception catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ErrorModel, List<ChildDataModel>>> getChildren() async {
    try {
      final result = await _fb.getChildren();

      List<ChildDataModel> children = [];
      result.docs.forEach((element) {
        children.add(ChildDataModel.fromJson(element.data()));
        if (children.isNotEmpty && children.last.appsData != null) {
          children.last.appsData!
              .sort((b, a) => a.dailyUsage!.compareTo(b.dailyUsage!));
        }
      });
      return Right(children);
    } on Exception catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteChild(
      {required String username}) async {
    try {
      await _fb.deleteChild(username: username);
      return const Right(null);
    } on Exception catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  /// /////////////////// APPs /////////////////

  @override
  Future<Either<ErrorModel, void>> updateBlockedApps({required List<String> blockedApps,required String childUsername})async{
     try {
      await _fb.updateBlockedApps(blockedApps: blockedApps, childUsername: childUsername);
      return const Right(null);
    } on Exception catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ErrorModel, void>> updateBlockedUrls({required List<String> blockedUrls,required String childUsername})async{
     try {
      await _fb.updateBlockedUrls(blockedUrls: blockedUrls, childUsername: childUsername);
      return const Right(null);
    } on Exception catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
