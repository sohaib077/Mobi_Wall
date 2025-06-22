import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/functions/show_location.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/assets_data.dart';
import 'package:mobi_wall/core/utils/date_time_handler.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/core/widgets/custom_card.dart';
import 'package:mobi_wall/core/widgets/empty_lottie_widget.dart';
import 'package:mobi_wall/features/children/data/models/smartwatch_data_model.dart';

class SmartWatchView extends StatelessWidget {
  const SmartWatchView({super.key, required this.smartwatchData});
  final SmartwatchDataModel? smartwatchData;

  @override
  Widget build(BuildContext context) {
    return smartwatchData == null
        ? const EmptyLottieWidget(lottie: AssetsData.emptyBoxLottie)
        : Column(
            children: [
              // Header
              _buildHeader(context),
              SizedBox(height: 20.h),

              // Heart Rate Card
              _buildHeartRateCard(context),
              SizedBox(height: 16.h),

              // Location Card
              _buildLocationCard(context),
              SizedBox(height: 16.h),

              // Last Updated Card
              _buildLastUpdatedCard(context),
            ],
          );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          IconBroken.Heart,
          size: 24.sp,
          color: AppColors.primaryColor,
        ),
        SizedBox(width: 8.w),
        Text(
          "Smart Watch Data",
          style: Styles.semiBold20Style(context, size: 18)
              .copyWith(color: AppColors.veryDarkBlue),
        ),
      ],
    );
  }

  Widget _buildHeartRateCard(BuildContext context) {
    return CustomCard(
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: _getHeartRateStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              IconBroken.Heart,
              size: 24.sp,
              color: _getHeartRateStatusColor(),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Heart Rate",
                  style: Styles.medium16Style(context, size: 14)
                      .copyWith(color: AppColors.labelTextColor),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      "${smartwatchData!.heartRate ?? '--'}",
                      style: Styles.semiBold20Style(context, size: 24)
                          .copyWith(color: _getHeartRateStatusColor()),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "BPM",
                      style: Styles.medium16Style(context, size: 14)
                          .copyWith(color: AppColors.labelTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: _getHeartRateStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              _getHeartRateStatus(),
              style: Styles.medium16Style(context, size: 12)
                  .copyWith(color: _getHeartRateStatusColor()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    return InkWell(
      onTap: () => showLocation(context, smartwatchData!.location),
      borderRadius: BorderRadius.circular(8.res(context)),
      child: CustomCard(
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                IconBroken.Location,
                size: 24.sp,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location",
                    style: Styles.medium16Style(context, size: 14)
                        .copyWith(color: AppColors.labelTextColor),
                  ),
                  SizedBox(height: 4.h),
                  _buildLocationInfo(context),
                ],
              ),
            ),
            Icon(
              IconBroken.Arrow___Right_2,
              size: 20.sp,
              color: AppColors.labelTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Lat: ",
              style: Styles.medium16Style(context, size: 12)
                  .copyWith(color: AppColors.labelTextColor),
            ),
            Expanded(
              child: Text(
                smartwatchData!.location.latitude.toStringAsFixed(6),
                style: Styles.medium16Style(context, size: 12)
                    .copyWith(color: AppColors.veryDarkBlue),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Text(
              "Lng: ",
              style: Styles.medium16Style(context, size: 12)
                  .copyWith(color: AppColors.labelTextColor),
            ),
            Expanded(
              child: Text(
                smartwatchData!.location.longitude.toStringAsFixed(6),
                style: Styles.medium16Style(context, size: 12)
                    .copyWith(color: AppColors.veryDarkBlue),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLastUpdatedCard(BuildContext context) {
    return CustomCard(
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColors.veryDarkBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              IconBroken.Time_Circle,
              size: 24.sp,
              color: AppColors.veryDarkBlue,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Last Updated",
                  style: Styles.medium16Style(context, size: 14)
                      .copyWith(color: AppColors.labelTextColor),
                ),
                SizedBox(height: 4.h),
                Text(
                  DateTimeHandler.toDateTimeFormat(smartwatchData!.updatedAt),
                  style: Styles.medium16Style(context, size: 13)
                      .copyWith(color: AppColors.veryDarkBlue),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: _getDataFreshnessColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: _getDataFreshnessColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  _getDataFreshnessStatus(),
                  style: Styles.medium16Style(context, size: 10)
                      .copyWith(color: _getDataFreshnessColor()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getHeartRateStatusColor() {
    if (smartwatchData!.heartRate == null) return AppColors.labelTextColor;

    final heartRate = smartwatchData!.heartRate!;
    if (heartRate < 50) return Colors.red;
    if (heartRate > 100) return Colors.orange;
    return Colors.green;
  }

  String _getHeartRateStatus() {
    if (smartwatchData!.heartRate == null) return "No Data";

    final heartRate = smartwatchData!.heartRate!;
    if (heartRate < 50) return "Low";
    if (heartRate > 100) return "High";
    return "Normal";
  }

  Color _getDataFreshnessColor() {
    final now = DateTime.now();
    final difference = now.difference(smartwatchData!.updatedAt);

    if (difference.inMinutes < 5) return Colors.green;
    if (difference.inMinutes < 30) return Colors.orange;
    return Colors.red;
  }

  String _getDataFreshnessStatus() {
    final now = DateTime.now();
    final difference = now.difference(smartwatchData!.updatedAt);

    if (difference.inMinutes < 5) return "Live";
    if (difference.inMinutes < 30) return "Recent";
    return "Stale";
  }
}
