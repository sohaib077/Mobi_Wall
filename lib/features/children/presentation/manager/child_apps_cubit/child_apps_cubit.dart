import 'dart:developer';
import 'package:app_usage/app_usage.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:meta/meta.dart';
import 'package:mobi_wall/core/enums/method_state_enum.dart';
import 'package:mobi_wall/core/errors/error_model.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/features/children/data/models/app_data_model.dart';
import 'package:mobi_wall/features/children/data/models/location_data_model.dart';
import 'package:mobi_wall/features/children/data/repos/child_apps_repo.dart';

part 'child_apps_state.dart';

class ChildAppsCubit extends Cubit<ChildAppsState> {
  ChildAppsCubit(this._childAppsRepo) : super(AppsInitial());

  static ChildAppsCubit get(context) => BlocProvider.of(context);

  final ChildAppsRepo _childAppsRepo;

  List<Map<String, dynamic>> apps = [];
  MethodState refreshAppsDataState = MethodState.init;

  Future<void> setlAppsList() async {
    apps.clear();
    // refreshAppsDataState = MethodState.loading;
    // emit(SetAppsListLoadingState());

    try {
      Map<String, Duration> dailyUsageMap = {};
      Map<String, Duration> weeklyUsageMap = {};
      Map<String, Duration> monthlyUsageMap = {};
      Map<String, DateTime> lastOpenedMap = {};

      List<AppInfo> appsInfo = await InstalledApps.getInstalledApps(true, true);

      appsInfo.forEach(
        (app) {
          log('app = ${app.name}');
        },
      );

      DateTime endDate = DateTime.now();
      // get daily usage
      DateTime startDate = endDate.subtract(const Duration(days: 1));
      List<AppUsageInfo> dayInfoList =
          await AppUsage().getAppUsage(startDate, endDate);
      // get weekly usage
      startDate = endDate.subtract(const Duration(days: 7));
      List<AppUsageInfo> weekInfoList =
          await AppUsage().getAppUsage(startDate, endDate);
      // get monthly usage
      startDate = endDate.subtract(const Duration(days: 30));
      List<AppUsageInfo> monthInfoList =
          await AppUsage().getAppUsage(startDate, endDate);

      dayInfoList.forEach((element) {
        dailyUsageMap[element.packageName] = element.usage;
      });

      weekInfoList.forEach((element) {
        weeklyUsageMap[element.packageName] = element.usage;
      });

      monthInfoList.forEach((element) {
        monthlyUsageMap[element.packageName] = element.usage;
        lastOpenedMap[element.packageName] = element.lastForeground;
      });

      appsInfo.forEach((e) {
        apps.add(
          AppDataModel(
            packageName: e.packageName,
            name: e.name,
            dailyUsage: dailyUsageMap[e.packageName],
            weeklyUsage: weeklyUsageMap[e.packageName],
            monthlyUsage: monthlyUsageMap[e.packageName],
          ).toMap(),
        );
        log(apps.last.toString());
      });
    } catch (error) {
      log('error = $error');
      refreshAppsDataState = MethodState.failed;
      emit(SetAppsListFailureState(error.toString()));
    }
  }

  Future<void> _refreshAppsData() async {
    if (refreshAppsDataState.isLoading()) return;

    refreshAppsDataState = MethodState.loading;
    emit(SetAppsListLoadingState());

    final result = await _childAppsRepo.uploadAppsData(apps: apps);

    result.fold(
      (error) {
        refreshAppsDataState = MethodState.failed;
        emit(SetAppsListFailureState(error.getErrorsMessage()));
      },
      (r) {
        refreshAppsDataState = MethodState.success;
        emit(SetAppsListSuccessState());
      },
    );
  }

  Position? position;
  MethodState refreshLocationState = MethodState.init;

  Future<void> _refreshLocationData() async {
    if (refreshLocationState.isLoading()) return;
    refreshLocationState = MethodState.loading;
    emit(GetLocationLoadingState());

    try {
      await checkLocationPermission();

      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      log("position = ${position!.toJson().toString()}");
      log("latitude = ${position!.latitude}");

      final result = await _childAppsRepo.uploadLocationData(
          location: LocationDataModel(
              latitude: position!.latitude, longitude: position!.longitude));

      result.fold(
        (error) {
          throw (error);
        },
        (r) {
          refreshLocationState = MethodState.success;
          emit(GetLocationSuccessState());
        },
      );
    } catch (error) {
      refreshLocationState = MethodState.failed;
      emit(
        GetLocationFailureState(
            error is ErrorModel ? error.getErrorsMessage() : error.toString()),
      );
    }
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission;

    if (!await Geolocator.isLocationServiceEnabled()) {
      log('Location services are disabled.');
      throw ('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permissions are denied');
        throw ('Location permissions are denied');
      }
    } else if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      log('Location permissions are permanently denied, we cannot request permissions.');
      throw ('Location permissions are permanently denied, we cannot request permissions');
    }
  }

  Future refreshData() async {
    await _refreshAppsData();
    await _refreshLocationData();
  }
}
