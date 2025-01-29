import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double widthBlock;
  static late double heightBlock;

  static const double desktop = 1200;
  static const double tablet = 800;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    // On my emulator the defaultSize = 10 almost
    widthBlock = screenWidth * 0.0275;
    heightBlock = screenHeight * 0.0156;
  }
}
