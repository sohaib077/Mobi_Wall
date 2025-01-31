import 'dart:developer';
import 'package:mobi_wall/features/auth/data/models/user_data_model.dart';
import '../utils/constants.dart';
import 'cache_helper.dart';

abstract class UserDataHelper {
  static Future<void> cacheUserData(UserDataModel userData) async {
    log('Caching  ${userData.toString()}');
    Constants.userData = userData;
    Constants.id = userData.id;
    await CacheHelper.saveJsonData(
        key: Constants.cachedUser, jsonData: userData.toMap());
    return await CacheHelper.saveSecuredString(
        key: Constants.cachedId, value: userData.id);
  }

  static Future<void> clearUserData() async {
    Constants.id = null;
    await CacheHelper.removeSecuredString(key: Constants.cachedUser);
    await CacheHelper.removeSecuredString(key: Constants.cachedId);
  }
}
