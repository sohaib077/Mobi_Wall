// Example usage of BehaviorAnalysisModel with dynamic keys
// This demonstrates how the model handles the JSON structure you provided

import 'package:mobi_wall/features/children/data/models/behavior_analysis_model.dart';

void exampleUsage() {
  // Example JSON data similar to what you provided
  final Map<String, dynamic> sampleData = {
    "behavior": "Bad",
    "appUsage": {
      "Music": 20,
      "Other": 10,
      "Social Media": 50,
    },
    "percentages": {
      "Music": 25.0,
      "Other": 12.5,
      "Social Media": 62.5,
    },
    "createdAt": DateTime.now(),
  };

  // Create model from JSON
  final behaviorAnalysis = BehaviorAnalysisModel.fromJson(sampleData);

  // Usage examples:
  print('Behavior: ${behaviorAnalysis.behavior}');
  print('Is problematic: ${behaviorAnalysis.isProblematicBehavior}');
  print('Total usage: ${behaviorAnalysis.totalAppUsage} minutes');
  print('Most used category: ${behaviorAnalysis.mostUsedCategory}');
  print('Categories: ${behaviorAnalysis.appCategories}');

  // Access specific values
  print(
      'Music usage: ${behaviorAnalysis.getAppUsageForCategory("Music")} minutes');
  print(
      'Social Media percentage: ${behaviorAnalysis.getPercentageForCategory("Social Media")}%');

  // Convert back to map
  final backToMap = behaviorAnalysis.toMap();
  print('Converted back to map: $backToMap');

  // Example with different dynamic keys
  final dynamicData = {
    "behavior": "Good",
    "appUsage": {
      "Gaming": 30,
      "Education": 45,
      "Communication": 15,
      "Productivity": 20,
    },
    "percentages": {
      "Gaming": 27.3,
      "Education": 40.9,
      "Communication": 13.6,
      "Productivity": 18.2,
    },
    "createdAt": DateTime.now(),
  };

  final dynamicBehaviorAnalysis = BehaviorAnalysisModel.fromJson(dynamicData);
  print('\nDynamic example:');
  print('Categories: ${dynamicBehaviorAnalysis.appCategories}');
  print('Most used: ${dynamicBehaviorAnalysis.mostUsedCategory}');
}
