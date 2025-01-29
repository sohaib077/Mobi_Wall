import 'package:flutter/material.dart';

abstract class SizeConfig {
  static late Size _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double widthBlock;
  static late double heightBlock;

  /// Break points
  static const double desktop = 800;

  static init(BuildContext context) {
    _mediaQueryData = MediaQuery.sizeOf(context);
    screenWidth = _mediaQueryData.width;
    screenHeight = _mediaQueryData.height;
    // // On my emulator the defaultSize = 10 almost
    // widthBlock = screenWidth * 0.0275;
    // heightBlock = screenHeight * 0.0156;
  }

  static bool isDesktop(context) {
    return screenWidth >= desktop;
  }

  static double getResponsiveFontSize(context, {required double fontSize}) {
    double scaleFactor = getScaleFactor(context);
    double responsiveFontSize = fontSize * scaleFactor;
    double lowerLimit = fontSize * .8;
    double upperLimit = fontSize * 1.5;
    return responsiveFontSize.clamp(lowerLimit, upperLimit);
  }

  static double getScaleFactor(context) {
    double width = MediaQuery.sizeOf(context).width;
    if (width < SizeConfig.desktop) {
      return width / 550;
    } else {
      return width / 700;
    }
  }
}
