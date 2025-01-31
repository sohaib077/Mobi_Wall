import 'package:flutter/material.dart';
import 'package:mobi_wall/core/functions/navigation.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/constants.dart';
import 'package:mobi_wall/core/utils/size_config.dart';
import 'package:mobi_wall/core/widgets/custom_logo.dart';
import 'package:mobi_wall/features/auth/presentation/views/auth_view.dart';
import '../../../onboarding/presentation/views/onboarding_view.dart';
import 'widgets/splash_loading_progress.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late Animation<double> _animation1;

  double progressWidth = 0;
  bool errorState = false;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation1 = Tween<double>(begin: 1, end: 1.9)
        .animate(CurvedAnimation(parent: _controller1, curve: Curves.easeOut));

    _animate();
  }

  void _animate() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      _controller1.forward().then((value) {
        _controller1.reverse().then((value) {
          Future.delayed(const Duration(milliseconds: 700), () async {
            if (Constants.id != null) {
              setState(() {
                progressWidth = SizeConfig.screenWidth * 0.25;
              });
              await Future.delayed(const Duration(milliseconds: 1000),
                  () async {
                await getUserData();
              });
            } else {
              Constants.onboarding
                  ? navigateAndFinish(context, const OnboardingView(),
                      fade: true)
                  : navigateAndFinish(context, const AuthView(), fade: true);
            }
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _animation1,
            child: const CustomLogo(),
          ),
          SplashLoadingProgress(progressWidth: progressWidth),
          if (errorState) _buildRetryButton(),
        ],
      ),
    );
  }

  IconButton _buildRetryButton() {
    return IconButton(
      onPressed: () async {
        setState(() {
          errorState = false;
          progressWidth = SizeConfig.screenWidth * 0.25;
        });
        await getUserData();
      },
      icon: Icon(
        Icons.refresh_rounded,
        size: 40.res(context),
        color: AppColors.veryDarkBlue,
      ),
    );
  }

  Future<void> getUserData() async {
    // await FirebaseServices.getUserData(id: Constants.id!).then((value) async {
    //   Constants.userData = UserDataModel.fromJson(value.data()!);
    //   setState(() {
    //     progressWidth = 0;
    //   });
    //   await Future.delayed(const Duration(milliseconds: 1000), () {
    //     if (Constants.childData != null) {
    //       navigateAndFinish(context, const ChildrenView(), fade: true);
    //     } else {
    //       Constants.isParent
    //           ? navigateAndFinish(context, const ParentChildrenView(),
    //               fade: true)
    //           : navigateAndFinish(context, const HomeView(), fade: true);
    //     }
    //   });
    // }).catchError((error) async {
    //   showAlertDialog(
    //     context,
    //     state: AlertState.failed,
    //     description:
    //         "Something went wrong, please check your network and try again",
    //   );
    //   setState(() {
    //     progressWidth = 0;
    //   });
    //   await Future.delayed(const Duration(milliseconds: 1400), () {
    //     setState(() {
    //       errorState = true;
    //     });
    //   });
    // });
  }
}
