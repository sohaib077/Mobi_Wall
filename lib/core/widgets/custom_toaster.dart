// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi_wall/core/enums/alert_state_enum.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/assets_data.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';
import 'package:mobi_wall/core/utils/styles.dart';

class CustomToaster extends StatefulWidget {
  const CustomToaster({
    super.key,
    required this.state,
    this.title,
    this.description,
    this.autoClose,
    this.onTap,
  });

  final AlertState state;
  final String? title;
  final String? description;
  final bool? autoClose;
  final VoidCallback? onTap;

  @override
  State<CustomToaster> createState() => _CustomToasterState();
}

class _CustomToasterState extends State<CustomToaster>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    animation = Tween<Offset>(begin: const Offset(0, 3), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    controller.forward();

    // if (widget.autoClose != true) controller.forward();
    //
    // if (widget.autoClose == true)
    //   controller.forward().then((value) {
    //     Future.delayed(const Duration(milliseconds: 700), () {
    //       if (mounted)
    //         controller.reverse().then((value) {
    //           Navigator.pop(context);
    //         });
    //     });
    //   });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop == false) {
          _pop(context);
        }
      },
      child: GestureDetector(
        onTap: () => _pop(context),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
          child: Container(
            color: Colors.transparent,
            height: double.infinity,
            padding: EdgeInsets.only(bottom: 20.res(context)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SlideTransition(
                  position: animation,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xff94A3B8).withOpacity(.45),
                            offset: const Offset(-1, 1),
                            blurRadius: 2),
                      ],
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: screenWidth * .04,
                            color: getColor(),
                          ),
                          const SizedBox(width: 5),
                          SvgPicture.asset(getIcon()),
                          const SizedBox(width: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: SizedBox(
                              width: screenWidth * .6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      widget.title ?? getTitle(),
                                      style:
                                          Styles.semiBold20Style(context, size: 14),
                                    ),
                                  if (widget.description != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        widget.description!,
                                        style: Styles.regular14Style(context,
                                            size: 12),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.close,
                            size: 16.sp,
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pop(BuildContext context) {
    controller.reverse().then(
      (value) {
        try {
          if (widget.onTap != null)
            widget.onTap!();
          else
            Navigator.pop(context);
        } catch (error) {
          log("Error from custom toaster = ${error.toString()}");
          Navigator.pop(context);
        }
      },
    );
  }

  Color getColor() {
    switch (widget.state) {
      case AlertState.success:
        return const Color(0xff1A8449);
      case AlertState.failed:
        return const Color(0xffCE1821);
      case AlertState.warning:
        return const Color(0xffFDB022);
    }
  }

  String getIcon() {
    switch (widget.state) {
      case AlertState.success:
        return AssetsData.doneIcon;
      case AlertState.failed:
        return AssetsData.failedIcon;
      case AlertState.warning:
        return AssetsData.alertIcon;
    }
  }

  String getTitle() {
    switch (widget.state) {
      case AlertState.success:
        return "Succeed!";
      case AlertState.failed:
        return "Something went wrong!";
      case AlertState.warning:
        return "Warning";
    }
  }
}
