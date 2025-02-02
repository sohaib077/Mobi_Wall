part of 'parent_cubit.dart';

@immutable
sealed class ParentState {}

final class ParentInitial extends ParentState {}

final class AddChildLoadingState extends ParentState {}

final class AddChildSuccessState extends ParentState {}

final class AddChildFailureState extends ParentState {
  final String message;

  AddChildFailureState(this.message);
}

final class GetChildrenLoadingState extends ParentState {}

final class GetChildrenSuccessState extends ParentState {}

final class GetChildrenFailureState extends ParentState {
  final String message;

  GetChildrenFailureState(this.message);
}

final class DeleteChildLoadingState extends ParentState {}

final class DeleteChildSuccessState extends ParentState {}

final class DeleteChildFailureState extends ParentState {
  final String message;

  DeleteChildFailureState(this.message);
}

final class ChangeCurrentChildState extends ParentState {}

final class BlockAppState extends ParentState {}

final class UnblockAppState extends ParentState {}

final class CheckIfBlockedAppsChangedState extends ParentState {}

final class ChangeShowSaveButtonState extends ParentState {}

final class UpdateBlockedAppsLoadingState extends ParentState {}

final class UpdateBlockedAppsSuccessState extends ParentState {}

final class UpdateBlockedAppsFailureState extends ParentState {
  final String message;

  UpdateBlockedAppsFailureState(this.message);
}

final class UpdateBlockedUrlsLoadingState extends ParentState {}

final class UpdateBlockedUrlsSuccessState extends ParentState {}

final class UpdateBlockedUrlsFailureState extends ParentState {
  final String message;

  UpdateBlockedUrlsFailureState(this.message);
}
