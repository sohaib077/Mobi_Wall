import 'dart:developer';
// import 'package:app_usage/app_usage.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:meta/meta.dart';
import 'package:mobi_wall/core/enums/alert_state_enum.dart';
import 'package:mobi_wall/core/enums/method_state_enum.dart';
import 'package:mobi_wall/core/services/firebase_services.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:mobi_wall/features/children/data/models/app_data_model.dart';
import 'package:mobi_wall/features/children/data/models/location_data_model.dart';

part 'child_apps_state.dart';

class ChildAppsCubit extends Cubit<ChildAppsState> {
  ChildAppsCubit() : super(AppsInitial());

  static ChildAppsCubit get(context) => BlocProvider.of(context);

  List<Map<String, dynamic>> apps = [];
  MethodState refreshAppsDataState = MethodState.init;

  // Future<void> setlAppsList(context) async {
  //   apps.clear();
  //   refreshAppsDataState = MethodState.loading;
  //   emit(SetAppsListLoadingState());
  //
  //   try {
  //     Map<String, Duration> dailyUsageMap = {};
  //     Map<String, Duration> weeklyUsageMap = {};
  //     Map<String, Duration> monthlyUsageMap = {};
  //     Map<String, DateTime> lastOpenedMap = {};
  //
  //     List<AppInfo> appsInfo = await InstalledApps.getInstalledApps(true, true);
  //
  //     DateTime endDate = DateTime.now();
  //     // get daily usage
  //     DateTime startDate = endDate.subtract(const Duration(days: 1));
  //     List<AppUsageInfo> dayInfoList =
  //         await AppUsage().getAppUsage(startDate, endDate);
  //     // get weekly usage
  //     startDate = endDate.subtract(const Duration(days: 7));
  //     List<AppUsageInfo> weekInfoList =
  //         await AppUsage().getAppUsage(startDate, endDate);
  //     // get monthly usage
  //     startDate = endDate.subtract(const Duration(days: 30));
  //     List<AppUsageInfo> monthInfoList =
  //         await AppUsage().getAppUsage(startDate, endDate);
  //
  //     dayInfoList.forEach((element) {
  //       dailyUsageMap[element.packageName] = element.usage;
  //     });
  //
  //     weekInfoList.forEach((element) {
  //       weeklyUsageMap[element.packageName] = element.usage;
  //     });
  //
  //     monthInfoList.forEach((element) {
  //       monthlyUsageMap[element.packageName] = element.usage;
  //       lastOpenedMap[element.packageName] = element.lastForeground;
  //     });
  //
  //     appsInfo.forEach((e) {
  //       apps.add(
  //         AppDataModel(
  //           packageName: e.packageName,
  //           name: e.name,
  //           dailyUsage: dailyUsageMap[e.packageName],
  //           weeklyUsage: weeklyUsageMap[e.packageName],
  //           monthlyUsage: monthlyUsageMap[e.packageName],
  //         ).toMap(),
  //       );
  //     });
  //   } catch (error) {
  //     refreshAppsDataState = MethodState.failed;
  //     emit(SetAppsListFailureState());
  //     showAlertDialog(context,
  //         state: AlertState.failed, description: error.toString());
  //   }
  // }

  Future<void> uploadAppsData(context) async {
    // uploading data to firebase
    log("uploading");
    await FirebaseService().refreshAppsData(apps: apps).then((value) {
      refreshAppsDataState = MethodState.success;
      emit(SetAppsListSuccessState());
    }).catchError((error) {
      log("error from here");
      refreshAppsDataState = MethodState.failed;
      emit(SetAppsListFailureState());
      showAlertDialog(context,
          state: AlertState.failed, description: error.toString());
    });
  }

  Position? position;
  MethodState refreshLocationState = MethodState.init;

  Future<void> uploadLocationData(BuildContext context) async {
    refreshLocationState = MethodState.loading;
    emit(GetLocationLoadingState());
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
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
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        log('Location permissions are permanently denied, we cannot request permissions.');
        throw ('Location permissions are permanently denied, we cannot request permissions');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((value) {
        position = value;
        log("position = ${position!.toJson().toString()}");
        log("latitude = ${position!.latitude}");

        FirebaseService().refreshLocationData(
                location: LocationDataModel(
                    latitude: position!.latitude,
                    longitude: position!.longitude))
            .then((value) {
          refreshLocationState = MethodState.success;
          emit(GetLocationSuccessState());
        }).catchError((error) {
          throw (error);
        });
      }).catchError((error) {
        throw (error);
      });
    } catch (e) {
      refreshLocationState = MethodState.failed;
      emit(GetLocationFailureState());
      showAlertDialog(context,
          state: AlertState.failed, description: e.toString());
    }
  }

}
