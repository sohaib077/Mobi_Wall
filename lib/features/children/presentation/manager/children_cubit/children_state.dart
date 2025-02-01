part of 'children_cubit.dart';

@immutable
sealed class ChildrenState {}

final class ChildrenInitial extends ChildrenState {}

final class LoginChildLoadingState extends ChildrenState {}
final class LoginChildSuccessState extends ChildrenState {}
final class LoginChildFailureState extends ChildrenState {}
