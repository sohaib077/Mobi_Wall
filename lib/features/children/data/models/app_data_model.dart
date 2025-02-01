
class AppDataModel {
  String packageName;
  String name;
  Duration? dailyUsage;
  Duration? weeklyUsage;
  Duration? monthlyUsage;

  AppDataModel({
    required this.packageName,
    required this.name,
    required this.dailyUsage,
    required this.weeklyUsage,
    required this.monthlyUsage,
  });

  factory AppDataModel.fromJson(Map<String, dynamic> json) {
    return AppDataModel(
      packageName: json['packageName'],
      name: json['name'],
      dailyUsage: Duration(milliseconds: json['dailyUsageTime']),
      weeklyUsage: Duration(milliseconds: json['weeklyUsageTime']),
      monthlyUsage: Duration(milliseconds: json['monthlyUsageTime']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'packageName': packageName,
      'name': name,
      'dailyUsageTime': dailyUsage?.inMilliseconds ?? 0,
      'weeklyUsageTime': weeklyUsage?.inMilliseconds ?? 0,
      'monthlyUsageTime': monthlyUsage?.inMilliseconds ?? 0,
    };
  }
}

// Duration parseDuration(String? s) {
//   if (s == null) {
//     return const Duration(hours: 0, minutes: 0, microseconds: 0);
//   }
//   int hours = 0;
//   int minutes = 0;
//   int micros;
//   List<String> parts = s.split(':');
//   if (parts.length > 2) {
//     hours = int.parse(parts[parts.length - 3]);
//   }
//   if (parts.length > 1) {
//     minutes = int.parse(parts[parts.length - 2]);
//   }
//   micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
//   return Duration(hours: hours, minutes: minutes, microseconds: micros);
// }
