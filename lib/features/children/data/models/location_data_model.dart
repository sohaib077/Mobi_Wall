class LocationDataModel {
  double latitude;
  double longitude;

  LocationDataModel({
    required this.latitude,
    required this.longitude,
  });

  factory LocationDataModel.fromJson(Map<String, dynamic> json) {
    return LocationDataModel(
      latitude: json['latitude'] ?? 0,
      longitude: json['longitude'] ?? 0,
    );
  }

  Map<String, dynamic>  toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
