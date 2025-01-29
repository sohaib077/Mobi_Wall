import 'package:flutter/material.dart';

import '../enums/alert_state_enum.dart';
import '../enums/method_state_enum.dart';
import '../utils/size_config.dart';

extension Responsive on num {
  double res(BuildContext context) {
    return SizeConfig.getResponsiveFontSize(context, fontSize: toDouble());
  }
}

extension MapExtension<k, v> on Map<k, v>? {
  bool isNullOrEmpty() => (this == null || this!.isEmpty);
}

extension ListExtension<T> on List<T>? {
  bool isNullOrEmpty() => (this == null || this!.isEmpty);
}


extension MethodStates on MethodState {
  bool isInit() => this == MethodState.init;

  bool isLoading() => this == MethodState.loading;

  bool isFailed() => this == MethodState.failed;

  bool isSuccess() => this == MethodState.success;

  bool isEmpty() => this == MethodState.empty;
}

extension AlertStatesExtension on AlertState {
  bool isLoading() => this == AlertState.success;

  bool isFailed() => this == AlertState.failed;

  bool isSuccess() => this == AlertState.warning;
}