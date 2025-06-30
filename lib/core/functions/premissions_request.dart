import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

Future<void> requestCallsAndPermissions() async {
  try {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
      Permission.locationAlways,
    ].request();
    statuses.forEach((permission, status) {
      log("Permission: ${permission.toString()}, Status: ${status.toString()}");
      if (status.isDenied) {}
    });
    print(statuses[Permission.location]);
  } catch (e) {
    log("Error requesting permissions: $e");
  }
}

Future<void> requestCallLogsPermission() async {
  try {
    // Request call log permission
    PermissionStatus callLogStatus = await Permission.phone.request();
    log("Call log permission status: ${callLogStatus.toString()}");

    if (callLogStatus.isDenied) {
      log("Call log permission denied");
    } else if (callLogStatus.isPermanentlyDenied) {
      log("Call log permission permanently denied");
      // Optionally open app settings
      // await openAppSettings();
    } else if (callLogStatus.isGranted) {
      log("Call log permission granted");
    }
  } catch (e) {
    log("Error requesting call logs permission: $e");
  }
}

Future<void> requestLocationPermissions() async {
  try {
    log("Requesting fine location permission...");

    // First check current status without requesting
    PermissionStatus locationStatus = await Permission.locationAlways.request();
    log("Fine location permission status: ${locationStatus.toString()}");
    // If not granted, then request
    if (!locationStatus.isGranted) {
      locationStatus = await Permission.locationAlways.request();
      log("Fine location permission status: ${locationStatus.toString()}");
    }

    if (locationStatus.isDenied) {
      log("Fine location permission denied");
      return;
    } else if (locationStatus.isPermanentlyDenied) {
      log("Fine location permission permanently denied");
      // Optionally open app settings
      // await openAppSettings();
      return;
    }

    log("Fine location permission granted");

    // Check when in use status without requesting first
    // PermissionStatus locationAlwaysStatus = await Permission.locationAlways.status;

    // // // Only request if not already granted
    // if (!locationAlwaysStatus.isGranted) {
    //   locationAlwaysStatus = await Permission.locationAlways.request();
    //   log("Location when in use permission status: ${locationAlwaysStatus.toString()}");
    // }
  } catch (e) {
    log("Error requesting location permissions: $e");
  }
}
