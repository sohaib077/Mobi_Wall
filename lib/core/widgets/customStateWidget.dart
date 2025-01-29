import 'package:flutter/material.dart';
import 'package:mobi_wall/core/enums/method_state_enum.dart';
import 'custom_empty_widget.dart';
import 'custom_error_widget.dart';
import 'custom_loading_page.dart';

class CustomStateWidget extends StatelessWidget {
  const CustomStateWidget(
      {super.key,
      required this.state,
      required this.widget,
      this.onError,
      this.condition = true,
      this.loadingWidget, this.emptyWidget});

  final MethodState state;
  final Widget widget;
  final void Function()? onError;
  final bool condition;

  final Widget? loadingWidget;
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    return state == MethodState.failed
        ? CustomErrorWidget(onPressed: onError)
        : state == MethodState.empty
            ? emptyWidget ?? const CustomEmptyWidget()
            : state == MethodState.success && condition
                ? widget
                : loadingWidget ?? const CustomLoadingPage();
  }
}
