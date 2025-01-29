import 'package:flutter/material.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/constants.dart';

import '../utils/app_colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {super.key,
      required this.child,
      this.horizontalPadding,
      this.verticalPadding});

  final Widget child;
  final double? horizontalPadding;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: AppColors.primaryColor.withOpacity(0.5),
      margin: EdgeInsets.all(2.res(context)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.res(context))),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 14.res(context),
            vertical: verticalPadding ?? 10.res(context)),
        child: child,
      ),
    );
  }
}
