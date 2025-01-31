import 'dart:convert';
import 'dart:developer';

import '../helpers/cache_helper.dart';
import '../utils/constants.dart';

Future<void> setupCacheHelper() async {
  await CacheHelper.init();

  Constants.onboarding =
      CacheHelper.getData(Constants.cachedOnboarding) ?? true;
  Constants.id = CacheHelper.getData(Constants.cachedId);
  Constants.otp = CacheHelper.getData(Constants.cachedOtp) ?? true;
  Constants.permissions =
      CacheHelper.getData(Constants.cachedPermissions) ?? true;
  Constants.iconHided = CacheHelper.getData(Constants.cachedIconHided) ?? false;
  Constants.isParent = CacheHelper.getData(Constants.cachedIsParent) ?? false;

  /// uncomment
  // var jsonData = CacheHelper.getData(Constants.cachedChild);
  // if (jsonData != null) {
  //   var cashedDataMap = jsonDecode(jsonData);
  //   Constants.childData = ChildDataModel.fromJson(cashedDataMap);
  // }

  log(" === onboarding === ${Constants.onboarding}");
  log(" === id === ${Constants.id}");
  log(" === otp === ${Constants.otp}");
  // log(" === child username === ${Constants.childData?.username}");
}
