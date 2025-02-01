part of 'child_apps_cubit.dart';

@immutable
sealed class ChildAppsState {}

final class AppsInitial extends ChildAppsState {}

final class SetAppsListLoadingState extends ChildAppsState {}
final class SetAppsListSuccessState extends ChildAppsState {}
final class SetAppsListFailureState extends ChildAppsState {}

final class GetLocationLoadingState extends ChildAppsState {}
final class GetLocationSuccessState extends ChildAppsState {}
final class GetLocationFailureState extends ChildAppsState {}
