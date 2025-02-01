import 'package:flutter/services.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import '../enums/alert_state_enum.dart';
import 'constants.dart';

class BackgroundServices {
  static const MethodChannel _channel =
      MethodChannel('com.example.myapp/installed_apps');

  static Future<void> startPeriodicDataRefreshing(context) async {
    String state = "";
    try {
      state = await _channel.invokeMethod('startPeriodicDataRefreshing', {
        "isChild": true,
        "id": Constants.id,
        "childName": Constants.childData?.username,
      });
    } on PlatformException catch (e) {
      showAlertDialog(context,
          state: AlertState.failed, description: "Try again, ${e.message}");
    }

    showAlertDialog(context,
        state:
            state.contains("try again") ? AlertState.failed : AlertState.success,
        description: "\n$state\n");
  }

  static Future<void> stopPeriodicTasks(context) async {
    String state = " ";
    try {
      state = await _channel.invokeMethod('stopPeriodicTasks');
    } on PlatformException catch (e) {
      showAlertDialog(context,
          state: AlertState.failed, description: "Try again, ${e.message}");
    }
    showAlertDialog(context, state: AlertState.success, description: "\n$state\n");
  }

  static Future<bool> getPermissions() async {
    bool state = false;
    try {
      state = await _channel.invokeMethod('getPermissions').then((value) async {
        return await _channel
            .invokeMethod("getUsageAccessPermission")
            .then((value) async {
          return await _channel.invokeMethod("blockUninstall");
        });
      });
    } on PlatformException catch (e) {
      print('Failed to retrieve installed apps: ${e.message}');
    }
    return state;
  }

  static Future<void> hideAppIcon() async {
    try {
      await _channel.invokeMethod('hideAppIcon');
    } on PlatformException catch (e) {
      print('Failed to retrieve installed apps: ${e.message}');
    }
  }

  static Future<void> showAppIcon() async {
    try {
      await _channel.invokeMethod('showAppIcon');
    } on PlatformException catch (e) {
      print('Failed to retrieve installed apps: ${e.message}');
    }
  }
}
