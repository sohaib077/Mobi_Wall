import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobi_wall/core/enums/alert_state_enum.dart';
import 'package:mobi_wall/core/enums/method_state_enum.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/helpers/notification_helper.dart';
import 'package:mobi_wall/core/services/firebase_services.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';
import 'package:mobi_wall/features/parent/data/repos/parent_repo.dart';

part 'parent_state.dart';

class ParentCubit extends Cubit<ParentState> {
  ParentCubit(this._parentRepo) : super(ParentInitial());

  static ParentCubit get(context) => BlocProvider.of(context);

  final ParentRepo _parentRepo;

  MethodState addChildState = MethodState.init;

  Future<void> addChild(
    context, {
    required String username,
    required String password,
  }) async {
    if (addChildState == MethodState.loading) return;
    addChildState = MethodState.loading;
    emit(AddChildLoadingState());

    final result = await _parentRepo.addChild(
        childData: ChildDataModel(
      username: username,
      password: password,
      createdDate: DateTime.now(),
    ));

    result.fold(
      (error) {
        addChildState = MethodState.failed;
        emit(AddChildFailureState(error.getErrorsMessage()));
      },
      (r) {
        getChildren();
        addChildState = MethodState.success;
        emit(AddChildSuccessState());
      },
    );
  }

  MethodState getChildrenState = MethodState.init;

  List<ChildDataModel> children = [];

  Future<void> getChildren() async {
    if (getChildrenState.isLoading()) return;
    getChildrenState = MethodState.loading;
    emit(GetChildrenLoadingState());

    final result = await _parentRepo.getChildren();
    result.fold(
      (error) {
        getChildrenState = MethodState.failed;
        emit(GetChildrenFailureState(error.getErrorsMessage()));
      },
      (childrenData) {
        children = childrenData;
        getChildrenState =
            children.isNotEmpty ? MethodState.success : MethodState.empty;
        emit(GetChildrenSuccessState());
      },
    );
  }

  MethodState deleteChildState = MethodState.init;

  Future<void> deleteChild(context, {required String username}) async {
    if (deleteChildState.isLoading()) return;
    deleteChildState = MethodState.loading;
    emit(DeleteChildLoadingState());
    final result = await _parentRepo.deleteChild(username: username);

    result.fold(
      (error) {
        deleteChildState = MethodState.failed;
        emit(DeleteChildFailureState(error.getErrorsMessage()));
      },
      (r) {
        getChildren();
        deleteChildState = MethodState.success;
        emit(DeleteChildSuccessState());
      },
    );
  }

  late ChildDataModel currentChild;

  void changeCurrentChildData(ChildDataModel child) {
    currentChild = child;

    blockedApps.clear();
    blockedApps.addAll(child.blockedApps!);

    blockedUrls.clear();
    blockedUrls.addAll(child.blockedUrls!);

    showSaveButton = false;
    isBlockedAppsChanged = false;
    emit(ChangeCurrentChildState());
  }

  /// ////////////////////// Blocking apps //////////////////////////////

  List<String> blockedApps = [];

  void blockApp({required String app}) {
    log("blocked apps before = ${blockedApps.toString()}");

    if (!blockedApps.contains(app)) blockedApps.add(app);
    log("blocked apps after = ${blockedApps.toString()}");
    checkIfBlockedAppsChanged();
  }

  void unBlockApp({required String app}) {
    blockedApps.remove(app);
    checkIfBlockedAppsChanged();
  }

  bool isBlockedAppsChanged = false;

  void checkIfBlockedAppsChanged() {
    isBlockedAppsChanged = false;
    if (blockedApps.length != currentChild.blockedApps!.length) {
      isBlockedAppsChanged = true;
    } else {
      currentChild.blockedApps!.forEach((element) {
        if (!blockedApps.contains(element)) {
          isBlockedAppsChanged = true;
        }
      });
    }
    if (isBlockedAppsChanged) showSaveButton = isBlockedAppsChanged;
    log("blocked apps length = ${blockedApps.length}");
    log("childBlockedApps length = ${currentChild.blockedApps!.length}");
    emit(CheckIfBlockedAppsChangedState());
  }

  bool showSaveButton = false;

  void changeShowSaveButton() {
    showSaveButton = isBlockedAppsChanged;
    emit(ChangeShowSaveButtonState());
  }

  MethodState updateBlockedAppsState = MethodState.init;

  Future<void> updateBlockedApps(context) async {
    if (updateBlockedAppsState.isLoading()) return;
    updateBlockedAppsState = MethodState.loading;
    emit(UpdateBlockedAppsLoadingState());

    final result = await _parentRepo.updateBlockedApps(
        blockedApps: blockedApps, childUsername: currentChild.username);
    result.fold(
      (error) {
        updateBlockedAppsState = MethodState.failed;
        emit(UpdateBlockedAppsFailureState(error.getErrorsMessage()));
      },
      (r) async {
        NotificationHelper.sendNotification(
          token: currentChild.token ?? "",
          updateBlockedApps: true,
          blockedApps: blockedApps,
          notification: false,
        );
        getChildren();
        updateBlockedAppsState = MethodState.success;
        emit(UpdateBlockedAppsSuccessState());
      },
    );
  }

  /// ////////////////////// Blocking urls //////////////////////////////

  List<String> blockedUrls = [];

  MethodState updateBlockedUrlsState = MethodState.init;

  Future<void> updateBlockedUrls(context,
      {required String url, bool delete = false}) async {
    if (updateBlockedUrlsState.isLoading()) return;
    if (!delete && blockedUrls.contains(url)) {
      showAlertDialog(
        context,
        state: AlertState.warning,
        description: "This url is already blocked",
      );
      return;
    }
    if (delete)
      blockedUrls.remove(url);
    else
      blockedUrls.add(url);
    updateBlockedUrlsState = MethodState.loading;
    emit(UpdateBlockedUrlsLoadingState());

    final result = await _parentRepo.updateBlockedUrls(
        blockedUrls: blockedUrls, childUsername: currentChild.username);
    result.fold(
      (error) {
        updateBlockedUrlsState = MethodState.failed;
        emit(UpdateBlockedUrlsFailureState(error.getErrorsMessage()));
      },
      (r) {
        updateBlockedUrlsState = MethodState.success;
        emit(UpdateBlockedUrlsSuccessState());
      },
    );
  }
}
