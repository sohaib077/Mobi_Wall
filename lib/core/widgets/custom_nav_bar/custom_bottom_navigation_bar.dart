// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/utils/constants.dart';
import 'package:mobi_wall/features/parent/presentation/manager/parent_cubit.dart';

import 'bottom_navigation_tab_animted_container.dart';
import 'buttom_navigation_bar_tap_item.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentCubit, ParentState>(
      buildWhen: (previous, current) => current is ChangeTabValueState,
      builder: (context, state) {
        return IntrinsicHeight(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Constants.borderRadius(context)),
                    topRight: Radius.circular(Constants.borderRadius(context)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 1,
                    ),
                  ],
                ),
                // Don't make it const
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 6.h + MediaQuery.of(context).padding.bottom,
                    top: 12.h,
                  ),

                  /// Don't make it const
                  child: Row(
                    children: [
                      BottomNavigationBarTabItem(
                        iconData: IconlyBroken.location,
                        selectedIconData: IconlyBold.location,
                        tapName: "Location",
                        index: 0,
                      ),
                      BottomNavigationBarTabItem(
                        iconData: IconlyBroken.category,
                        selectedIconData: IconlyBold.category,
                        tapName: "Apps",
                        index: 1,
                      ),
                      BottomNavigationBarTabItem(
                        iconData: IconlyBroken.call,
                        selectedIconData: IconlyBold.call,
                        tapName: "Calls",
                        index: 2,
                      ),
                      BottomNavigationBarTabItem(
                        iconData: IconlyBroken.timeCircle,
                        selectedIconData: IconlyBold.timeCircle,
                        tapName: "Smart Watch",
                        index: 3,
                      ),
                      // BottomNavigationBarTabItem(
                      //   iconData: IconlyBroken.hide,
                      //   selectedIconData: IconlyBold.hide,
                      //   tapName: "Urls",
                      //   index: 3,
                      // ),
                    ],
                  ),
                ),
              ),
              BottomNavigationTabAnimatedContainer(
                currentTabIndex: ParentCubit.get(context).currentTab,
                tabsCount: 4,
              ),
            ],
          ),
        );
      },
    );
  }
}
