class LocationDataModel {
  double latitude;
  double longitude;

  LocationDataModel({
    required this.latitude,
    required this.longitude,
  });

  factory LocationDataModel.fromJson(Map<String, dynamic> json) {
    return LocationDataModel(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return 'LocationDataModel(latitude: $latitude, longitude: $longitude)';
  }
}
