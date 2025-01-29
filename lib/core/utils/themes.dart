import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

abstract class Themes {
  static AppBarTheme appBarTheme = const AppBarTheme(
    toolbarHeight: 0,
    surfaceTintColor: Colors.transparent,
    systemOverlayStyle:  SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  static TextSelectionThemeData textSelectionThemeData = TextSelectionThemeData(
    cursorColor: AppColors.primaryColor.withOpacity(0.8),
    selectionColor: AppColors.primaryColor.withOpacity(0.2),
    selectionHandleColor: AppColors.primaryColor.withOpacity(0.5),
  );
}
