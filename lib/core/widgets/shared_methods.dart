import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import 'package:mobi_wall/core/enums/alert_state_enum.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swipe_back_detector/swipe_back_detector.dart';

import 'custom_toaster.dart';

// ============================ N A V I G A T I O N S ======================================

void navigateTo(BuildContext context, Widget page,
    {double x = 1.0, double y = 0.0, bool fade = false}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = Offset(x, y);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SwipeBackDetector(
          child: fade
              ? FadeTransition(
                  opacity: animation,
                  child: child,
                )
              : SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                ),
        );
      },
    ),
  );
}

void navigateAndFinish(BuildContext context, widget,
        {double x = 1.0, double y = 0.0, bool fade = false}) =>
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final begin = Offset(x, y);
            const end = Offset.zero;
            const curve = Curves.ease;
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SwipeBackDetector(
              child: fade
                  ? FadeTransition(
                      opacity: animation,
                      child: child,
                    )
                  : SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    ),
            );
          },
        ), (route) {
      return false;
    });

// =============================================================================================

enum ToastStates { SUCCESS, ERROR, WARNING }

void customSnackBar(BuildContext context,
    {required String? text, Color? color, ToastStates? state, int? seconds}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      content: Directionality(
        textDirection: TextDirection.ltr,
        child: Text(
          text ?? "Something wrong please try again",
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      duration: Duration(seconds: seconds ?? 2),
      backgroundColor: color ??
          (state == ToastStates.SUCCESS ? Colors.lightGreen : Colors.redAccent),
    ),
  );
}

void unfocus(context) {
  FocusScope.of(context).unfocus();
}

Shimmer shimmerLoadingContainer(
    {double? width,
    double? height,
    Color? color,
    BorderRadiusGeometry? borderRadiusGeometry,
    Widget? child}) {
  return Shimmer.fromColors(
    baseColor: AppColors.shimmerBaseColor,
    highlightColor: AppColors.shimmerHighlightColorColor,
    direction: ShimmerDirection.rtl,
    child: child ??
        Container(
          width: width ?? double.infinity,
          height: height ?? 50.h,
          decoration: BoxDecoration(
            color: color ?? Colors.blue,
            borderRadius: borderRadiusGeometry ?? BorderRadius.circular(10.r),
          ),
        ),
  );
}

// ========================================================================================== //

Future<dynamic> showAlertDialog(
  BuildContext context, {
  AlertState state = AlertState.failed,
  String? title,
  String? description,
  bool autoClose = false,
  VoidCallback? onTap,
}) {
  return showDialog(
    barrierColor: Colors.transparent,
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: CustomToaster(
          state: state,
          title: title,
          description: description,
          autoClose: autoClose,
          onTap: onTap,
        ),
      );
    },
  );
}

// ========================================================================================== //

String extractFirebaseErrorMessage({required message}) {
  return message.substring(message.indexOf(']') + 1);
}

void showFirebaseErrorMessage(context, {required String message}) {
  showAlertDialog(
    context,
    state: AlertState.failed,
    description: extractFirebaseErrorMessage(message: message),
  );
}

// ========================================================================================== //
String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  if (duration.inHours == 0)
    return "$twoDigitMinutes:$twoDigitSeconds";
  else
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
