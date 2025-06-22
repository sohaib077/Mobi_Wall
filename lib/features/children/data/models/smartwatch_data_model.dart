import 'location_data_model.dart';

class SmartwatchDataModel {
  LocationDataModel location;
  int ?heartRate;
  DateTime updatedAt;

  SmartwatchDataModel({
    required this.location,
    required this.heartRate,
    required this.updatedAt,
  });

  factory SmartwatchDataModel.fromJson(Map<String, dynamic> json) {
    return SmartwatchDataModel(
      location: LocationDataModel.fromJson(json['location']),
      heartRate: json['heartRate'],
      updatedAt: json['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location.toMap(),
      'heartRate': heartRate,
      'updatedAt': DateTime.now(),
    };
  }
}
