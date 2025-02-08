import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/enums/method_state_enum.dart';
import 'package:mobi_wall/core/helpers/cache_helper.dart';
import 'package:mobi_wall/core/services/firebase_services.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/background_services.dart';
import 'package:mobi_wall/core/utils/constants.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';
import 'package:mobi_wall/core/utils/size_config.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/core/widgets/custom_card.dart';
import 'package:mobi_wall/core/widgets/custom_elevated_button.dart';
import 'package:mobi_wall/core/widgets/custom_log_out_button.dart';
import 'package:mobi_wall/features/children/presentation/manager/child_apps_cubit/child_apps_cubit.dart';

class ChildrenView extends StatefulWidget {
  const ChildrenView({super.key});

  @override
  State<ChildrenView> createState() => _ChildrenViewState();
}

class _ChildrenViewState extends State<ChildrenView> {
  @override
  void initState() {
    super.initState();

    if (Constants.permissions) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showInfoDialog(context);
      });
    } else {
      BackgroundServices.getPermissions();
      BackgroundServices.getUsageAccessAndAdminActivation();
    }

    FirebaseService().updateChildToken().then((value) {
      log("child token is updated successfully and token = \n$value");
    }).catchError((error) {
      log("Error while updating child token : $error");
    });

    // BackgroundServices.getPermissions();
  }

  void _refreshData() {
    /// uncomment
    // ChildAppsCubit.get(context).setlAppsList(context).then((value) {
    ChildAppsCubit.get(context).uploadAppsData(context).then((value) {
      ChildAppsCubit.get(context).uploadLocationData(context);
    });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => ChildAppsCubit(),
        child: BlocBuilder<ChildAppsCubit, ChildAppsState>(
          builder: (context, state) {
            MethodState refreshAppsState =
                ChildAppsCubit.get(context).refreshAppsDataState;
            MethodState refreshLocationState =
                ChildAppsCubit.get(context).refreshLocationState;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10.h),
                  const Row(
                    children: [
                      Spacer(),
                      CustomLogOutButton(),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "WELCOME\n${Constants.childData!.username}",
                    style: Styles.semiBold20Style(context),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  _buildItem(context,
                      state: refreshAppsState, text: "Refreshing apps Data"),
                  SizedBox(height: 20.h),
                  _buildItem(context,
                      state: refreshLocationState,
                      text: "Refreshing current location"),
                  // SizedBox(height: 20.h),
                  // HideAppCard(),
                  const Spacer(flex: 2),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth * 0.15),
                    child: CustomElevatedButton(
                        onPressed: () {
                          _showPeriodicRefreshingDialog(context);
                        },
                        color: AppColors.veryDarkBlue,
                        text: "Manage periodic refreshing"),
                  ),
                  SizedBox(height: 20.h),
                  CustomElevatedButton(
                      onPressed: () async {
                        if (refreshAppsState != MethodState.loading ||
                            refreshLocationState != MethodState.loading) {
                          _refreshData();
                        }
                      },
                      text: "Refresh data"),
                  const Spacer(flex: 2),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  CustomCard _buildItem(BuildContext context,
      {required MethodState state, required String text}) {
    return CustomCard(
        child: Row(
      children: [
        Expanded(
            child: Text(
          text,
          style: Styles.medium25Style(context, size: 16)
              .copyWith(color: Colors.black, letterSpacing: 1),
        )),
        state == MethodState.loading
            ? const CircularProgressIndicator(color: AppColors.primaryColor)
            : state == MethodState.failed
                ? Icon(IconBroken.Info_Circle, color: Colors.red, size: 30.sp)
                : state == MethodState.success
                    ? Icon(IconBroken.Shield_Done,
                        color: Colors.green, size: 30.sp)
                    : Icon(IconBroken.More_Circle,
                        color: AppColors.darkGray, size: 30.sp),
      ],
    ));
  }

  _showInfoDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: Styles.medium16Style(context)
            .copyWith(color: AppColors.primaryColor),
      ),
      onPressed: () async {
        CacheHelper.saveData(key: Constants.cachedPermissions, value: false);
        Navigator.pop(context);
        await BackgroundServices.getUsageAccessAndAdminActivation();
        // BackgroundServices.startPeriodicDataRefreshing();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      title: Column(
        children: [
          Icon(
            IconBroken.Danger,
            color: Colors.orange,
            size: 40.sp,
          ),
          SizedBox(height: 10.h),
          Text(
            "Permissions",
            style: Styles.semiBold20Style(context),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRichText(
              title: "Firstly : \n",
              content:
                  "Permit usage access for MobiWall from Usage access screen."),
          _buildRichText(
              title: "Secondly : \n",
              content:
                  "Give MobiWall location, call logs and phone permissions."),
        ],
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showPeriodicRefreshingDialog(BuildContext context) {
    // set up the button
    Widget startButton = Expanded(
        child: CustomElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        BackgroundServices.startPeriodicDataRefreshing(context);
      },
      text: "Start",
      color: Colors.green,
      verticalPadding: 5.h,
      overlayColor: Colors.greenAccent,
    ));
    Widget stopButton = Expanded(
        child: CustomElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        BackgroundServices.stopPeriodicTasks(context);
        // showModalBottomSheet(
        //   shape: Constants.modalSheetDecoration(),
        //   isScrollControlled: true,
        //   context: context,
        //   builder: (context) {
        //     return PasswordBottomSheet(
        //       actionTitle: "S T O P",
        //       action: () {
        //         Navigator.pop(context);
        //         BackgroundServices.stopPeriodicTasks(context);
        //       },
        //     );
        //   },
        // );
      },
      text: "Stop",
      color: Colors.red,
      verticalPadding: 5.h,
      overlayColor: Colors.redAccent,
    ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      title: Column(
        children: [
          Icon(
            IconBroken.Info_Circle,
            color: Colors.orange,
            size: 40.sp,
          ),
          SizedBox(height: 10.h),
          Text(
            "Periodic Data Refreshing",
            style: Styles.semiBold20Style(context, size: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRichText(
              title: "Start : \n",
              content:
                  "The child data will be refreshed periodically every 15 minutes."),
          _buildRichText(
              title: "Stop : \n",
              content: "The child data will not be refreshed anymore."),
          _buildRichText(
              title: "Reset : \n",
              content:
                  "If the child data isn't refreshed as expected you can press Stop button then Start one to reset it."),
        ],
      ),
      actions: [
        Row(
          children: [
            startButton,
            SizedBox(width: 20.w),
            stopButton,
          ],
        ),
      ],
    );

    // show the dialog
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildRichText({required String title, required String content}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: Styles.medium16Style(context, size: 12)
                  .copyWith(color: AppColors.veryDarkBlue),
            ),
            TextSpan(
              text: content,
              style: Styles.regular14Style(context, size: 12)
                  .copyWith(color: AppColors.labelTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
