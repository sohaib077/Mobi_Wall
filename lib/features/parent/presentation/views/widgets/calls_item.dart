import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/utils/date_time_handler.dart';
import 'package:mobi_wall/core/widgets/custom_card.dart';
import 'package:mobi_wall/core/widgets/custom_slide_transition.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/features/children/data/models/calls_model.dart';

class CallItem extends StatelessWidget {
  const CallItem({
    super.key,
    required this.call,
    required this.index,
  });

  final CallsModel call;
  final int index;

  @override
  Widget build(BuildContext context) {
    return CustomSlideTransition(
      index: index,
      child: Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  callState(call.type),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (call.name != null)
                          Text(
                            call.name!,
                            style: Styles.medium25Style(context, size: 15)
                                .copyWith(
                                    color: Colors.black, letterSpacing: 1),
                          ),
                        Text(
                          call.number,
                          style: Styles.regular14Style(context, size: 12)
                              .copyWith(
                                  color: AppColors.labelTextColor,
                                  letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatDuration(call.duration),
                    style: Styles.regular14Style(context, size: 12)
                        .copyWith(color: Colors.black, letterSpacing: 1),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  DateTimeHandler.toDateTimeFormat(call.date),
                  style: Styles.regular14Style(context, size: 8)
                      .copyWith(color: AppColors.darkGray),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
     INCOMING_TYPE = 1
     OUTGOING_TYPE = 2
     MISSED_TYPE = 3
   */

  Widget callState(String type) {
    return type == "3"
        ? Icon(IconBroken.Call_Missed, size: 25.sp, color: Colors.redAccent)
        : type == "1"
            ? Icon(IconBroken.Calling, size: 25.sp, color: Colors.green)
            : Icon(IconBroken.Calling, size: 25.sp, color: Colors.blue);
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return hoursStr == "00"
        ? '$minutesStr:$secondsStr'
        : '$hoursStr:$minutesStr:$secondsStr';
  }
}
