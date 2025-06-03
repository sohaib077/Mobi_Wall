import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/utils/constants.dart';
import 'package:mobi_wall/core/utils/size_config.dart';

class BottomNavigationTabAnimatedContainer extends StatelessWidget {
  const BottomNavigationTabAnimatedContainer({
    super.key,
    required this.currentTabIndex,
    required this.tabsCount,
  });

  final int currentTabIndex;
  final int tabsCount;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      top: 0,
      left: (SizeConfig.screenWidth / tabsCount) * currentTabIndex,
      curve: Curves.easeInOut,
      child: Container(
        width: SizeConfig.screenWidth / tabsCount,
        height: 6.h,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(Constants.borderRadius(context)),
            bottomRight: Radius.circular(Constants.borderRadius(context)),
          ),
        ),
      ),
    );
  }
}
