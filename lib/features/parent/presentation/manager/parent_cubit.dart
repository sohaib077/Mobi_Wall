import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobi_wall/core/enums/alert_state_enum.dart';
import 'package:mobi_wall/core/enums/method_state_enum.dart';
import 'package:mobi_wall/core/helpers/notification_helper.dart';
import 'package:mobi_wall/core/services/firebase_services.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';

import '../../data/models/child_data_model.dart';

part 'parent_state.dart';

class ParentCubit extends Cubit<ParentState> {
  ParentCubit() : super(ParentInitial());

  static ParentCubit get(context) => BlocProvider.of(context);

  MethodState addChildState = MethodState.init;

  void addChild(
    context, {
    required String username,
    required String password,
  }) {
    if (addChildState == MethodState.loading) return;
    addChildState = MethodState.loading;
    emit(AddChildLoadingState());

    FirebaseService().setChildData(
        childData: ChildDataModel(
      username: username,
      password: password,
      createdDate: DateTime.now(),
    )).then((value) {
      addChildState = MethodState.success;
      emit(AddChildSuccessState());
      Future.delayed(const Duration(milliseconds: 500), () {
        getChildren(context);
        addChildState = MethodState.init;
        emit(AddChildSuccessState());
        Navigator.pop(context);
      });
    }).catchError((error) {
      addChildState = MethodState.init;
      emit(AddChildFailureState());
      showFirebaseErrorMessage(context, message: error.toString());
    });
  }

  MethodState getChildrenState = MethodState.init;

  List<ChildDataModel> children = [];

  Future<void> getChildren(context) async {
    children = [];
    getChildrenState = MethodState.loading;
    emit(GetChildrenLoadingState());
    await FirebaseService().getChildren().then((value) {
      value.docs.forEach((element) {
        children.add(ChildDataModel.fromJson(element.data()));
        if (children.isNotEmpty && children.last.appsData != null) {
          children.last.appsData!
              .sort((b, a) => a.dailyUsage!.compareTo(b.dailyUsage!));
        }
      });

      if (children.isNotEmpty) currentChild = children.first;

      getChildrenState =
          children.isNotEmpty ? MethodState.success : MethodState.empty;
      emit(GetChildrenSuccessState());
    }).catchError((error) {
      getChildrenState = MethodState.failed;
      emit(GetChildrenFailureState());
      showFirebaseErrorMessage(context, message: error.toString());
    });
  }

  MethodState deleteChildState = MethodState.init;

  void deleteChild(context, {required String username}) {
    if (deleteChildState == MethodState.loading) return;
    deleteChildState = MethodState.loading;
    emit(DeleteChildLoadingState());
    FirebaseService().deleteChild(username: username).then((value) {
      getChildren(context);
      deleteChildState = MethodState.success;
      emit(DeleteChildSuccessState());
      Navigator.pop(context);
    }).catchError((error) {
      deleteChildState = MethodState.failed;
      emit(DeleteChildFailureState());
      showFirebaseErrorMessage(context, message: error.toString());
    });
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
    // emit(BlockAppState());
  }

  void unBlockApp({required String app}) {
    blockedApps.remove(app);
    checkIfBlockedAppsChanged();
    // emit(UnblockAppState());
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

  void updateBlockedApps(context) {
    if (updateBlockedAppsState == MethodState.loading) return;
    updateBlockedAppsState = MethodState.loading;
    emit(UpdateBlockedAppsLoadingState());
    FirebaseService().updateBlockedApps(
            blockedApps: blockedApps, childUsername: currentChild.username)
        .then((value) async {
      Navigator.pop(context);
      showAlertDialog(
        context,
        state: AlertState.success,
        description: "Blocked apps are updated successfully",
      );
      NotificationHelper.sendNotification(
        context,
        token: currentChild.token ?? "",
        updateBlockedApps: true,
        blockedApps: blockedApps,
        notification: false,
      );
      getChildren(context).then((value) {
        updateBlockedAppsState = MethodState.success;
        emit(UpdateBlockedAppsSuccessState());
      });
    }).catchError((error) {
      updateBlockedAppsState = MethodState.failed;
      emit(UpdateBlockedAppsFailureState());
      log("error = ${error.toString()}");
      showFirebaseErrorMessage(context, message: error.toString());
    });
  }

  /// ////////////////////// Blocking urls //////////////////////////////

  List<String> blockedUrls = [];

  MethodState updateBlockedUrlsState = MethodState.init;

  void updateBlockedUrls(context, {required String url, bool delete = false}) {
    if (updateBlockedUrlsState == MethodState.loading) return;
    if (!delete && blockedUrls.contains(url)) {
      showAlertDialog(
        context,
        state: AlertState.warning,
        description: "\nThis url is already blocked\n",
      );
      return;
    }
    if (delete)
      blockedUrls.remove(url);
    else
      blockedUrls.add(url);
    updateBlockedUrlsState = MethodState.loading;
    emit(UpdateBlockedUrlsLoadingState());
    FirebaseService().updateBlockedUrls(
            blockedUrls: blockedUrls, childUsername: currentChild.username)
        .then((value) async {
      getChildren(context).then((value) {
        updateBlockedUrlsState = MethodState.success;
        emit(UpdateBlockedUrlsSuccessState());
        Future.delayed(const Duration(milliseconds: 500), () {
          updateBlockedUrlsState = MethodState.init;
          emit(AddChildSuccessState());
          Navigator.pop(context);
          Navigator.pop(context);
          showAlertDialog(
            context,
            state: AlertState.success,
            description: "Blocked urls are updated successfully",
          );
        });
        // NotificationHelper.sendNotification(
        //   context,
        //   token: currentChild.token ?? "",
        //   updateBlockedApps: true,
        //   blockedApps: blockedApps,
        //   notification: false,
        // );
      });
    }).catchError((error) {
      updateBlockedUrlsState = MethodState.init;
      emit(UpdateBlockedUrlsFailureState());
      log("error = ${error.toString()}");
      showFirebaseErrorMessage(context, message: error.toString());
    });
  }
}
