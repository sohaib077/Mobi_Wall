import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/widgets/custom_card.dart';
import 'package:mobi_wall/core/widgets/custom_slide_transition.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/features/children/data/models/app_data_model.dart';
import 'package:mobi_wall/features/parent/presentation/manager/parent_cubit.dart';

class AppItem extends StatefulWidget {
  const AppItem({
    super.key,
    required this.app,
    required this.index,
    required this.state,
  });

  final AppDataModel app;
  final int index;
  final bool state;

  @override
  State<AppItem> createState() => _AppItemState();
}

class _AppItemState extends State<AppItem> {
  @override
  Widget build(BuildContext context) {
    // bool on = !ParentCubit.get(context).blockedApps.contains(widget.app.packageName);
    return CustomSlideTransition(
      index: widget.index,
      child: Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: CustomCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.app.name,
                      style: Styles.medium16Style(context, size: 14)
                          .copyWith(color: Colors.black),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "${widget.app.dailyUsage?.inMinutes.toString() ?? "0"} minutes used today",
                      style: Styles.medium16Style(context, size: 12).copyWith(
                          color: const Color(0xff00091F).withOpacity(0.4)),
                    ),
                  ],
                ),
              ),
              Switch(
                splashRadius: 0,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                trackColor: MaterialStateProperty.all(widget.state
                    ? AppColors.primaryColor
                    : const Color(0xff00091F).withOpacity(0.15)),
                activeColor: const Color(0xffF7F7F7),
                trackOutlineColor:
                    MaterialStateProperty.all(Colors.transparent),
                inactiveThumbColor: const Color(0xffF7F7F7),
                value: widget.state,
                onChanged: (value) => setState(() {
                  if (value) {
                    ParentCubit.get(context)
                        .unBlockApp(app: widget.app.packageName);
                  } else {
                    ParentCubit.get(context)
                        .blockApp(app: widget.app.packageName);
                  }
                  // on = !on;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
