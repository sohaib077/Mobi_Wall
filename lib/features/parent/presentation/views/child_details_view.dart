// ignore_for_file: sort_child_properties_last

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';
import 'package:mobi_wall/core/utils/size_config.dart';
import 'package:mobi_wall/core/widgets/custom_title_app_bar.dart';
import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/block_url_floating_action_button.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/url_blocking_view.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/apps_list.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/calls_list.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/location_details_view.dart';
import 'package:geocode/geocode.dart';

class ChildDetailsView extends StatefulWidget {
  const ChildDetailsView({super.key, required this.child});

  final ChildDataModel child;

  @override
  State<ChildDetailsView> createState() => _ChildDetailsViewState();
}

class _ChildDetailsViewState extends State<ChildDetailsView>
    with SingleTickerProviderStateMixin {
  Address? address;

  late int currentPage;
  late TabController tabController;

  static const Color selectedColor = Colors.white;
  static const Color unselectedColor = AppColors.darkGray;

  static const double radius = 30;

  @override
  void initState() {
    super.initState();
    currentPage = 0;
    tabController = TabController(length: 4, vsync: this);
    tabController.animation!.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAddress();
    });
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> getAddress() async {
    GeoCode geoCode = GeoCode();
    address = await geoCode.reverseGeocoding(
      latitude: widget.child.locationData?.latitude ?? 0,
      longitude: widget.child.locationData?.longitude ?? 0,
    );

    log(address?.toString() ?? "null");
    setState(() {});
    // return "${address.city} -- ${address.streetAddress}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          currentPage == 3 ? const BlockUrlFloatingActionButton() : null,
      body: SafeArea(
        child: BottomBar(
          width: SizeConfig.screenWidth * .6,
          child: TabBar(
            splashBorderRadius: BorderRadius.circular(radius),
            dividerColor: Colors.transparent,
            overlayColor:
                WidgetStatePropertyAll(Colors.white.withOpacity(0.1)),
            indicatorPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            controller: tabController,
            indicator: UnderlineTabIndicator(
              borderSide: const BorderSide(color: selectedColor, width: 2.5),
              borderRadius: BorderRadius.circular(1.r),
              insets: const EdgeInsets.fromLTRB(2, 0, 2, 8),
            ),
            tabs: [
              // _buildIcon(icon: IconBroken.Activity, index: 1),
              _buildIcon(icon: IconBroken.Location, index: 0),
              _buildIcon(icon: IconBroken.Category, index: 1),
              _buildIcon(icon: IconBroken.Call, index: 2),
              _buildIcon(icon: Icons.network_check_rounded, index: 3),
            ],
          ),
          fit: StackFit.expand,
          borderRadius: BorderRadius.circular(radius),
          barColor: AppColors.veryDarkBlue,
          body: (context, controller) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                CustomTitleAppBar(title: widget.child.username),
                currentPage == 1
                    ? AppsList(apps: widget.child.appsData)
                    : currentPage == 2
                        ? CallsList(calls: widget.child.calls)
                        : currentPage == 3
                            ? UrlBlockingView(urls: widget.child.blockedUrls)
                            : LocationDetailsView(
                                location: widget.child.locationData,
                                address: address),
                // SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildIcon({required IconData icon, required int index}) {
    return SizedBox(
      height: 55,
      width: 40,
      child: Center(
          child: Icon(
        icon,
        color: currentPage == index ? selectedColor : unselectedColor,
      )),
    );
  }
}
