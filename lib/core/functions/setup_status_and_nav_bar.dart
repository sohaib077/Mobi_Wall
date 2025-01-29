import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> setupStatusAndNavBar() async {
  //transparent nav bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}
