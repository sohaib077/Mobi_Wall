import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobi_wall/core/functions/setup_service_locator.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/date_time_handler.dart';
import 'package:mobi_wall/core/widgets/custom_card.dart';
import 'package:mobi_wall/core/widgets/custom_deleting_alert_dialog.dart';
import 'package:mobi_wall/core/widgets/custom_slide_transition.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';
import 'package:mobi_wall/features/parent/presentation/manager/parent_cubit.dart';
import 'package:mobi_wall/features/parent/presentation/views/child_details_view.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/empty_child_data_view.dart';

class ChildItem extends StatelessWidget {
  const ChildItem({
    super.key,
    required this.child,
    required this.index,
  });

  final ChildDataModel child;
  final int index;

  @override
  Widget build(BuildContext context) {
    return CustomSlideTransition(
      index: index,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                icon: IconBroken.Delete,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.red,
                borderRadius: BorderRadius.circular(10.r),
                autoClose: true,
                onPressed: (BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (context) => BlocProvider.value(
                      value: sl<ParentCubit>(),
                      child: BlocConsumer<ParentCubit, ParentState>(
                        listener: (context, state) => _listener(context, state),
                        builder: (context, state) {
                          return CustomDeletingAlertDialog(
                            text: "Wanna delete this child !",
                            loading: ParentCubit.get(context)
                                .deleteChildState
                                .isLoading(),
                            onDeleting: () {
                              ParentCubit.get(context).deleteChild(context,
                                  username: child.username);
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              ParentCubit.get(context).changeCurrentChildData(child);
              navigateTo(
                  context,
                  child.appsData == null
                      ? EmptyChildDataView(username: child.username)
                      : ChildDetailsView(child: child));
            },
            borderRadius: BorderRadius.circular(10.r),
            highlightColor: AppColors.primaryColor.withOpacity(0.5),
            splashColor: AppColors.primaryColor.withOpacity(0.5),
            child: CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        child.username,
                        style: Styles.medium25Style(context, size: 15)
                            .copyWith(color: Colors.black, letterSpacing: 1),
                      )),
                      const Spacer(),
                      Icon(IconBroken.Arrow___Right_2, size: 30.sp),
                    ],
                  ),
                  if (child.updatedDate != null) SizedBox(height: 1.h),
                  if (child.updatedDate != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Refreshed at   ",
                          style: Styles.medium16Style(context, size: 8)
                              .copyWith(color: AppColors.labelTextColor),
                        ),
                        Text(
                          DateTimeHandler.toDateTimeFormat(child.updatedDate!),
                          style: Styles.regular14Style(context, size: 8)
                              .copyWith(color: AppColors.darkGray),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _listener(BuildContext context, ParentState state) {
    if (state is DeleteChildSuccessState) Navigator.pop(context);
    if (state is DeleteChildFailureState) {
      showAlertDialog(
        context,
        description: state.message,
        onTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    }
  }
}
