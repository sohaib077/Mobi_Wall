import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/utils/themes.dart';
import 'package:mobi_wall/features/splash/presentation/views/splash_view.dart';
import 'core/functions/setup_cache_helper.dart';
import 'core/functions/setup_service_locator.dart';
import 'core/functions/setup_status_and_nav_bar.dart';
import 'core/utils/app_colors.dart';
import 'core/utils/custom_bloc_observer.dart';
import 'core/utils/size_config.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupStatusAndNavBar();
  await setupCacheHelper();
  setupServiceLocator();
  Bloc.observer = CustomBlocObserver();
  runApp(const MobiWall());
}

class MobiWall extends StatelessWidget {
  const MobiWall({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            colorScheme:
                ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
            useMaterial3: true,
            appBarTheme: Themes.appBarTheme,
            textSelectionTheme: Themes.textSelectionThemeData,
          ),
          home: const SplashView(),
        ),
      ),
    );
  }
}
