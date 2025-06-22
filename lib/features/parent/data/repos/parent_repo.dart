import 'package:dartz/dartz.dart';
import 'package:mobi_wall/features/children/data/models/behavior_analysis_model.dart';
import '../../../../core/errors/error_model.dart';
import '../models/child_data_model.dart';

abstract class ParentRepo {
  Future<Either<ErrorModel, void>> addChild(
      {required ChildDataModel childData});
  Future<Either<ErrorModel, List<ChildDataModel>>> getChildren();
  Future<Either<ErrorModel, void>> deleteChild({required String username});
  Future<Either<ErrorModel, void>> updateBlockedApps(
      {required List<String> blockedApps, required String childUsername});
  Future<Either<ErrorModel, void>> updateBlockedUrls(
      {required List<String> blockedUrls, required String childUsername});
  Future<Either<ErrorModel, List<BehaviorAnalysisModel>>> getBehaviorAnalysis(
      {required String childUsername});
}
