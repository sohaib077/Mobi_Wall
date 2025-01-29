import 'package:flutter/material.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
// import 'package:mobiwall/features/parent/data/models/child_data_model.dart';

abstract class Constants {
  /// Values
  static double horizontalPadding(context) => 24.res(context);

  static double borderRadius(context) => 8.res(context);

  static const String cachedOnboarding = 'onboarding';
  static const String cachedId = 'id';
  static const String cachedOtp = 'otp';
  static const String cachedChild = 'child';
  static const String cachedPermissions = 'permissions';
  static const String cachedIconHided = 'iconHided';
  static const String cachedIsParent = 'isParent';

  // static ChildDataModel? childData;

  static late bool onboarding;

  static late bool otp;
  static late bool permissions;
  static late bool iconHided;
  static late bool isParent;

  static String? id;

  // static late UserDataModel userData;

  //This is  the device token which used in FCM
  // static Future<String?> getToken() async {
  //   return await FirebaseMessaging.instance.getToken();
  // }

  static RoundedRectangleBorder modalSheetDecoration() =>
      const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ));
}
