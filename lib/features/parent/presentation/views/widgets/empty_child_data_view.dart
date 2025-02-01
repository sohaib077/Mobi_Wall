import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/utils/assets_data.dart';
import 'package:mobi_wall/core/widgets/custom_empty_state_widget.dart';
import 'package:mobi_wall/core/widgets/custom_title_app_bar.dart';

class EmptyChildDataView extends StatelessWidget {
  const EmptyChildDataView({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                CustomTitleAppBar(title: username),
                SizedBox(height: 20.h),
                const CustomEmptyStateWidget(
                  text:
                      "You must open this child account in his device first to get the data",
                  lottie: AssetsData.emptyBoxLottie,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
