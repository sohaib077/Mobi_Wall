class BehaviorAnalysisModel {
  String behavior;
  Map<String, num> appUsage; // Changed to num to handle both int and double
  Map<String, double> percentages;
  DateTime createdAt;

  BehaviorAnalysisModel({
    required this.behavior,
    required this.appUsage,
    required this.percentages,
    required this.createdAt,
  });

  factory BehaviorAnalysisModel.fromJson(Map<String, dynamic> json) {
    return BehaviorAnalysisModel(
      behavior: json['behavior'] ?? 'Unknown',
      appUsage: Map<String, num>.from(
        (json['appUsage'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(key, (value as num)),
        ),
      ),
      percentages: Map<String, double>.from(
        (json['percentages'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
      createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'behavior': behavior,
      'appUsage': appUsage,
      'percentages': percentages,
      'createdAt': createdAt,
    };
  }

  /// Returns a list of all app categories found in appUsage
  List<String> get appCategories => appUsage.keys.toList();

  /// Returns a list of all percentage categories
  List<String> get percentageCategories => percentages.keys.toList();

  /// Get app usage time for a specific category
  /// Returns 0 if category doesn't exist
  int getAppUsageForCategory(String category) {
    return appUsage[category]?.toInt() ?? 0;
  }

  /// Get percentage for a specific category
  /// Returns 0.0 if category doesn't exist
  double getPercentageForCategory(String category) {
    return percentages[category] ?? 0.0;
  }

  /// Check if behavior is considered problematic
  bool get isProblematicBehavior {
    return behavior.toLowerCase() == 'bad' ||
        behavior.toLowerCase() == 'very bad';
  }

  /// Get the total app usage time across all categories
  int get totalAppUsage {
    return appUsage.values
        .map((value) => value.toInt())
        .fold(0, (sum, value) => sum + value);
  }

  /// Get the category with highest usage
  String? get mostUsedCategory {
    if (appUsage.isEmpty) return null;

    String maxCategory = appUsage.keys.first;
    int maxUsage = getAppUsageForCategory(maxCategory);

    for (String category in appUsage.keys) {
      int usage = getAppUsageForCategory(category);
      if (usage > maxUsage) {
        maxCategory = category;
        maxUsage = usage;
      }
    }

    return maxCategory;
  }

  /// Get the category with highest percentage
  String? get mostUsedPercentageCategory {
    if (percentages.isEmpty) return null;

    String maxCategory = percentages.keys.first;
    double maxPercentage = percentages[maxCategory]!;

    for (String category in percentages.keys) {
      double percentage = percentages[category]!;
      if (percentage > maxPercentage) {
        maxCategory = category;
        maxPercentage = percentage;
      }
    }

    return maxCategory;
  }

  @override
  String toString() {
    return 'BehaviorAnalysisModel{behavior: $behavior, appUsage: $appUsage, percentages: $percentages, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BehaviorAnalysisModel &&
        other.behavior == behavior &&
        _mapsEqual(other.appUsage, appUsage) &&
        _mapsEqual(other.percentages, percentages) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return behavior.hashCode ^
        appUsage.hashCode ^
        percentages.hashCode ^
        createdAt.hashCode;
  }

  /// Helper method to compare maps
  bool _mapsEqual<T>(Map<String, T> map1, Map<String, T> map2) {
    if (map1.length != map2.length) return false;

    for (String key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) {
        return false;
      }
    }

    return true;
  }
}
