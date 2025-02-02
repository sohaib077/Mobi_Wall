import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/enums/alert_state_enum.dart';
import 'package:mobi_wall/core/utils/assets_data.dart';
import 'package:mobi_wall/core/enums/method_state_enum.dart';
import 'package:mobi_wall/core/widgets/custom_card.dart';
import 'package:mobi_wall/core/widgets/empty_lottie_widget.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/features/children/data/models/app_data_model.dart';
import 'package:mobi_wall/features/parent/presentation/manager/parent_cubit.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/app_item.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/app_usage_view.dart';

class AppsList extends StatelessWidget {
  const AppsList({
    super.key,
    required this.apps,
  });

  final List<AppDataModel>? apps;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentCubit, ParentState>(
      listener: (context, state) => _listener(context, state),
      builder: (context, state) {
        return Expanded(
          child: Column(
            children: [
              if (ParentCubit.get(context).showSaveButton)
                GestureDetector(
                  onTap: () {
                    ParentCubit.get(context).updateBlockedApps(context);
                  },
                  child: Column(
                    children: [
                      const CustomCard(
                              child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("Tap here to save the changes")],
                      ))
                          .animate(
                            target:
                                ParentCubit.get(context).isBlockedAppsChanged
                                    ? 1
                                    : 0,
                            onComplete: (controller) {
                              if (!ParentCubit.get(context)
                                  .isBlockedAppsChanged)
                                ParentCubit.get(context).changeShowSaveButton();
                            },
                          )
                          .scale(
                              // begin: ParentCubit.get(context).isBlockedAppsChanged ?  0 : 1,
                              // end: ParentCubit.get(context).isBlockedAppsChanged ?  1 : 0,
                              duration: 800.ms,
                              curve: Curves.easeInOut),
                      if (ParentCubit.get(context).updateBlockedAppsState ==
                          MethodState.loading)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 10.w),
                          child: LinearProgressIndicator(
                            color: AppColors.primaryColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(5.r),
                            minHeight: 3.h,
                          ),
                        )
                    ],
                  ),
                ),
              Expanded(
                child: apps == null ||
                        apps!.isEmpty ||
                        (apps!.length == 1 &&
                            apps!.first.name.contains("mobiwall"))
                    ? const EmptyLottieWidget(lottie: AssetsData.emptyBoxLottie)
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: apps?.length ?? 0,
                        itemBuilder: (context, index) {
                          return apps![index]
                                  .packageName
                                  .contains("com.example.mobiwall")
                              ? const SizedBox()
                              : Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          index == apps!.length - 1 ? 60.h : 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      navigateTo(context,
                                          AppUsageView(app: apps![index]));
                                    },
                                    child: AppItem(
                                      app: apps![index],
                                      index: index,
                                      state: !ParentCubit.get(context)
                                          .blockedApps
                                          .contains(apps![index].packageName),
                                    ),
                                  ),
                                );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  _listener(BuildContext context, ParentState state) {
    if (state is UpdateBlockedAppsFailureState) {
      showAlertDialog(
        context,
        description: state.message,
      );
    } else if (state is UpdateBlockedAppsSuccessState) {
      Navigator.pop(context);
      showAlertDialog(
        context,
        state: AlertState.success,
        description: "Blocked apps are updated successfully",
      );
    }
  }
}
