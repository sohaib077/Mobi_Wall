import 'dart:convert';
import 'dart:developer';

import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';

import '../helpers/cache_helper.dart';
import '../utils/constants.dart';

Future<void> setupCacheHelper() async {
  await CacheHelper.init();

  Constants.onboarding =
      CacheHelper.getData(Constants.cachedOnboarding) ?? true;
  Constants.id = await CacheHelper.getSecuredString(key:Constants.cachedId);
  Constants.otp = CacheHelper.getData(Constants.cachedOtp) ?? true;
  Constants.permissions =
      CacheHelper.getData(Constants.cachedPermissions) ?? true;
  Constants.iconHided = CacheHelper.getData(Constants.cachedIconHided) ?? false;
  Constants.isParent = CacheHelper.getData(Constants.cachedIsParent) ?? false;



  var jsonData = CacheHelper.getJsonData(Constants.cachedChild);
  if (jsonData != null) {
    Constants.childData = ChildDataModel.fromJson(jsonData);
  }

  log(" === onboarding === ${Constants.onboarding}");
  log(" === id === ${Constants.id}");
  log(" === otp === ${Constants.otp}");
  log(" === child username === ${Constants.childData?.username}");
}
