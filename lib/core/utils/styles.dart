import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'assets_data.dart';
import 'size_config.dart';

abstract class Styles {
  static TextStyle semiBold20Style(context, {double? size}) {
    return TextStyle(
      fontSize: SizeConfig.getResponsiveFontSize(context, fontSize: size ?? 20),
      fontWeight: FontWeight.w600,
      fontFamily: AssetsData.poppinsFontFamily,
      color: AppColors.veryDarkBlue,
    );
  }

  static TextStyle medium25Style(context, {double? size}) {
    return TextStyle(
      fontSize: SizeConfig.getResponsiveFontSize(context, fontSize: size ?? 25),
      fontWeight: FontWeight.w500,
      fontFamily: AssetsData.poppinsFontFamily,
      color: AppColors.veryDarkBlue,
    );
  }

  static TextStyle medium16Style(context, {double? size}) {
    return TextStyle(
      fontSize: SizeConfig.getResponsiveFontSize(context, fontSize: size ?? 16),
      fontWeight: FontWeight.w500,
      fontFamily: AssetsData.poppinsFontFamily,
      color: AppColors.veryDarkBlue,
    );
  }

  static TextStyle regular16Style(context, {double? size}) {
    return TextStyle(
      fontSize: SizeConfig.getResponsiveFontSize(context, fontSize: size ?? 16),
      fontWeight: FontWeight.w400,
      fontFamily: AssetsData.poppinsFontFamily,
      color: AppColors.labelTextColor,
    );
  }

  static TextStyle regular14Style(context, {double? size}) {
    return TextStyle(
      fontSize: SizeConfig.getResponsiveFontSize(context, fontSize: size ?? 14),
      fontWeight: FontWeight.w400,
      fontFamily: AssetsData.poppinsFontFamily,
      color: AppColors.veryDarkBlue,
    );
  }

  static TextStyle bold24Style(context, {double? size}) {
    return TextStyle(
      fontSize: SizeConfig.getResponsiveFontSize(context, fontSize: size ?? 24),
      fontWeight: FontWeight.w700,
      fontFamily: AssetsData.poppinsFontFamily,
      color: AppColors.veryDarkBlue,
    );
  }

  /// Another styles

  static ButtonStyle customButtonStyle({Color? color, Color? overlayColor}) {
    return ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor:
            WidgetStatePropertyAll(color ?? AppColors.primaryColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        overlayColor: WidgetStatePropertyAll(overlayColor ?? Colors.blue));
  }
}
