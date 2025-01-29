import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheHelper {
  static late SharedPreferences _sharedPreferences;
  static late FlutterSecureStorage _storage;

  static init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _storage = const FlutterSecureStorage();
  }

  static Future<void> clear() async {
    await _sharedPreferences.clear();
  }

  static dynamic getData(String key) {
    return _sharedPreferences.get(key);
  }

  static Future<bool?> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _sharedPreferences.setString(key, value);
    if (value is int) return await _sharedPreferences.setInt(key, value);
    if (value is bool) return await _sharedPreferences.setBool(key, value);
    return await _sharedPreferences.setDouble(key, value);
  }

  static Future<bool> removeData(
    String key,
  ) async {
    return await _sharedPreferences.remove(key);
  }

  static Future<bool?> saveJsonData(
      {required String key, required Map<String, dynamic>? jsonData}) async {
    return await saveData(key: key, value: jsonEncode(jsonData));
  }

  static dynamic getJsonData(String key) {
    var jsonData = getData(key);
    if (jsonData != null) {
      var cachedDataMap = jsonDecode(jsonData);
      return cachedDataMap;
    }
    return null;
  }

  static Future<void> saveSecuredString(
      {required String key, required String value}) async {
    return await _storage.write(key: key, value: value);
  }

  static Future<String?> getSecuredString({required String key}) async {
    return await _storage.read(key: key);
  }

  static Future<void> removeSecuredString({required String key}) async {
    return await _storage.delete(key: key);
  }
}

abstract class CachedStrings {
  // static const userId = "id";
}
