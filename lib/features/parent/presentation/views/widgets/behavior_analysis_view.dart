import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/enums/method_state_enum.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/assets_data.dart';
import 'package:mobi_wall/core/utils/date_time_handler.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/core/widgets/custom_card.dart';
import 'package:mobi_wall/core/widgets/empty_lottie_widget.dart';
import 'package:mobi_wall/features/children/data/models/behavior_analysis_model.dart';
import 'package:mobi_wall/features/parent/presentation/manager/parent_cubit.dart';

class BehaviorAnalysisView extends StatefulWidget {
  const BehaviorAnalysisView({super.key, required this.behaviorAnalysisList});
  final List<BehaviorAnalysisModel>? behaviorAnalysisList;

  @override
  State<BehaviorAnalysisView> createState() => _BehaviorAnalysisViewState();
}

class _BehaviorAnalysisViewState extends State<BehaviorAnalysisView> {
  final Set<int> _expandedItems = <int>{};
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ParentCubit, ParentState>(
        builder: (context, state) {
          final cubit = ParentCubit.get(context);
          final isLoading =
              cubit.getBehaviorAnalysisState == MethodState.loading;
          final isError = cubit.getBehaviorAnalysisState == MethodState.failed;
          final isEmpty = widget.behaviorAnalysisList == null ||
              widget.behaviorAnalysisList!.isEmpty;
          log('isLoading: $isLoading, isError: $isError, isEmpty: $isEmpty');
          return RefreshIndicator(
            onRefresh: () async {
              await cubit.getBehaviorAnalysis();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  // Header - always visible
                  _buildHeader(context),
                  SizedBox(height: 20.h),

                  // Content based on state
                  if (isLoading)
                    // Initial loading with skeleton
                    _buildLoadingSkeleton(context)
                  else if (isError)
                    // Error state
                    _buildErrorState(context, cubit)
                  else if (isEmpty)
                    // Empty state
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: const EmptyLottieWidget(
                          lottie: AssetsData.emptyBoxLottie),
                    )
                  else
                    // Data loaded - show content with optional loading overlay
                    Stack(
                      children: [
                        Column(
                          children: [
                            // List of all behavior analyses
                            ...widget.behaviorAnalysisList!
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final analysis = entry.value;
                              return _buildBehaviorAnalysisCard(
                                  context, analysis, index);
                            }),
                          ],
                        ),
                        // Overlay loading indicator for refresh
                        if (isLoading && !isEmpty)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8.h),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor,
                                ),
                                minHeight: 2.h,
                              ),
                            ),
                          ),
                      ],
                    ),

                  // Bottom padding for safe area
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          IconBroken.Chart,
          size: 24.sp,
          color: AppColors.primaryColor,
        ),
        SizedBox(width: 8.w),
        Text(
          "Behavior Analysis",
          style: Styles.semiBold20Style(context, size: 18)
              .copyWith(color: AppColors.veryDarkBlue),
        ),
      ],
    );
  }

  Widget _buildBehaviorAnalysisCard(
      BuildContext context, BehaviorAnalysisModel analysis, int index) {
    final isExpanded = _expandedItems.contains(index);

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.res(context)),
        onTap: () {
          setState(() {
            if (isExpanded) {
              _expandedItems.remove(index);
            } else {
              _expandedItems.add(index);
            }
          });
        },
        child: CustomCard(
          child: Padding(
            padding: EdgeInsets.all(16.res(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Behavior Status Header - Always visible
                _buildBehaviorHeader(context, analysis, isExpanded),

                // Expandable content
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    children: [
                      SizedBox(height: 16.h),

                      // App Usage Section
                      if (analysis.appCategories.isNotEmpty) ...[
                        _buildAppUsageSection(context, analysis),
                        SizedBox(height: 16.h),
                      ],

                      // Percentages Section
                      if (analysis.percentageCategories.isNotEmpty)
                        _buildPercentagesSection(context, analysis),
                    ],
                  ),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBehaviorHeader(
      BuildContext context, BehaviorAnalysisModel analysis, bool isExpanded) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color:
                    _getBehaviorStatusColor(analysis.behavior).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                _getBehaviorIcon(analysis.behavior),
                size: 24.sp,
                color: _getBehaviorStatusColor(analysis.behavior),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateTimeHandler.toDateTimeFormat(analysis.createdAt),
                    style: Styles.medium16Style(context, size: 12)
                        .copyWith(color: AppColors.labelTextColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    analysis.behavior,
                    style: Styles.semiBold20Style(context, size: 18).copyWith(
                        color: _getBehaviorStatusColor(analysis.behavior)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Expand/Collapse indicator
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                IconBroken.Arrow___Down_2,
                size: 20.sp,
                color: AppColors.labelTextColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color:
                    _getBehaviorStatusColor(analysis.behavior).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                _getBehaviorStatusText(analysis.behavior),
                style: Styles.medium16Style(context, size: 12).copyWith(
                    color: _getBehaviorStatusColor(analysis.behavior)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppUsageSection(
      BuildContext context, BehaviorAnalysisModel analysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              IconBroken.Time_Circle,
              size: 18.sp,
              color: AppColors.primaryColor,
            ),
            SizedBox(width: 8.w),
            Text(
              "App Usage (minutes)",
              style: Styles.semiBold20Style(context, size: 14)
                  .copyWith(color: AppColors.veryDarkBlue),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...analysis.appCategories.map((category) {
          final usage = analysis.getAppUsageForCategory(category);
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    _formatCategoryName(category),
                    style: Styles.medium16Style(context, size: 13)
                        .copyWith(color: AppColors.labelTextColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 1,
                  child: Text(
                    "$usage min",
                    style: Styles.medium16Style(context, size: 13)
                        .copyWith(color: AppColors.veryDarkBlue),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        if (analysis.appCategories.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Divider(color: AppColors.labelTextColor.withOpacity(0.2)),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "Total Usage",
                  style: Styles.semiBold20Style(context, size: 13)
                      .copyWith(color: AppColors.veryDarkBlue),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                flex: 1,
                child: Text(
                  "${analysis.totalAppUsage} min",
                  style: Styles.semiBold20Style(context, size: 14)
                      .copyWith(color: AppColors.primaryColor),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPercentagesSection(
      BuildContext context, BehaviorAnalysisModel analysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              IconBroken.Chart,
              size: 18.sp,
              color: AppColors.primaryColor,
            ),
            SizedBox(width: 8.w),
            Text(
              "Usage Percentages",
              style: Styles.semiBold20Style(context, size: 14)
                  .copyWith(color: AppColors.veryDarkBlue),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...analysis.percentageCategories.map((category) {
          final percentage = analysis.getPercentageForCategory(category);
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        _formatCategoryName(category),
                        style: Styles.medium16Style(context, size: 13)
                            .copyWith(color: AppColors.labelTextColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "${percentage.toStringAsFixed(1)}%",
                        style: Styles.medium16Style(context, size: 13)
                            .copyWith(color: AppColors.veryDarkBlue),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2.r),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: AppColors.labelTextColor.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getCategoryColor(category),
                    ),
                    minHeight: 4.h,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        if (analysis.mostUsedPercentageCategory != null) ...[
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.res(context)),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  IconBroken.Star,
                  size: 14.sp,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    "Most used: ${_formatCategoryName(analysis.mostUsedPercentageCategory!)}",
                    style: Styles.medium16Style(context, size: 12)
                        .copyWith(color: AppColors.primaryColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Color _getBehaviorStatusColor(String behavior) {
    switch (behavior.toLowerCase()) {
      case 'good':
      case 'very good':
        return Colors.green;
      case 'bad':
        return Colors.orange;
      case 'very bad':
        return Colors.red;
      default:
        return AppColors.labelTextColor;
    }
  }

  IconData _getBehaviorIcon(String behavior) {
    switch (behavior.toLowerCase()) {
      case 'good':
      case 'very good':
        return IconBroken.Shield_Done;
      case 'bad':
      case 'very bad':
        return IconBroken.Danger;
      default:
        return IconBroken.Info_Circle;
    }
  }

  String _getBehaviorStatusText(String behavior) {
    switch (behavior.toLowerCase()) {
      case 'good':
        return 'Good';
      case 'very good':
        return 'Excellent';
      case 'bad':
        return 'Concerning';
      case 'very bad':
        return 'Alert';
      default:
        return 'Unknown';
    }
  }

  String _formatCategoryName(String category) {
    // Convert camelCase or snake_case to Title Case
    return category
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ')
        .trim();
  }

  Color _getCategoryColor(String category) {
    // Assign different colors to different categories
    switch (category.toLowerCase()) {
      case 'music':
        return Colors.purple;
      case 'social media':
      case 'socialmedia':
        return Colors.blue;
      case 'games':
      case 'gaming':
        return Colors.orange;
      case 'education':
      case 'educational':
        return Colors.green;
      case 'entertainment':
        return Colors.red;
      case 'productivity':
        return Colors.teal;
      case 'other':
        return AppColors.labelTextColor;
      default:
        return AppColors.primaryColor;
    }
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: CustomCard(
            child: Padding(
              padding: EdgeInsets.all(16.res(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header skeleton
                  Row(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: AppColors.labelTextColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 12.h,
                              decoration: BoxDecoration(
                                color:
                                    AppColors.labelTextColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 16.h,
                              decoration: BoxDecoration(
                                color:
                                    AppColors.labelTextColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Content skeleton
                  ...List.generate(
                      4,
                      (index) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 12.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.labelTextColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  width: 40.w,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.labelTextColor
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                ),
                              ],
                            ),
                          )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ParentCubit cubit) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconBroken.Info_Circle,
            size: 64.sp,
            color: Colors.red.withOpacity(0.7),
          ),
          SizedBox(height: 16.h),
          Text(
            "Failed to load behavior analysis",
            style: Styles.semiBold20Style(context, size: 16)
                .copyWith(color: AppColors.veryDarkBlue),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            "Something went wrong while fetching the data",
            style: Styles.medium16Style(context, size: 12)
                .copyWith(color: AppColors.labelTextColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => cubit.getBehaviorAnalysis(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, size: 16.sp),
                SizedBox(width: 8.w),
                Text(
                  "Retry",
                  style: Styles.medium16Style(context, size: 14)
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ...existing methods...
}
