import 'package:mobi_wall/features/children/data/models/app_data_model.dart';
import 'package:mobi_wall/features/children/data/models/calls_model.dart';
import 'package:mobi_wall/features/children/data/models/location_data_model.dart';
import 'package:mobi_wall/features/children/data/models/smartwatch_data_model.dart';

class ChildDataModel {
  String username;
  String password;
  DateTime? createdDate;
  DateTime? updatedDate;
  List<AppDataModel>? appsData;
  LocationDataModel? locationData;

  String? token;

  List<String>? blockedApps;
  List<String>? blockedUrls;
  List<CallsModel>? calls;
  SmartwatchDataModel? smartwatchData;
  ChildDataModel({
    required this.username,
    required this.password,
    required this.createdDate,
    this.updatedDate,
    this.appsData,
    this.locationData,
    this.token,
    this.blockedApps,
    this.blockedUrls,
    this.calls,
    this.smartwatchData,
  });

  factory ChildDataModel.fromJson(Map<String, dynamic> json) {
    return ChildDataModel(
      username: json['username'] ?? 'none',
      password: json['password'] ?? 'none',
      token: json['token'],
      blockedApps: json['blockedApps'] == null
          ? []
          : (json['blockedApps'] as List).map((e) => e.toString()).toList(),
      blockedUrls: json['blockedUrls'] == null
          ? []
          : (json['blockedUrls'] as List).map((e) => e.toString()).toList(),
      createdDate: json['createdDate']?.toDate(),
      updatedDate: json['updatedDate']?.toDate(),
      locationData: json['location'] == null
          ? null
          : LocationDataModel.fromJson(json['location']),
      appsData: json["apps"] == null
          ? null
          : (json["apps"] as List)
              .map((e) => AppDataModel.fromJson(e))
              .toList(),
      calls: json["calls"] == null
          ? null
          : (json["calls"] as List).map((e) => CallsModel.fromJson(e)).toList(),
      smartwatchData: json["smartwatchData"] == null
          ? null
          : SmartwatchDataModel.fromJson(json["smartwatchData"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'token': token,
      // 'createdDate': createdDate,
    };
  }
}
