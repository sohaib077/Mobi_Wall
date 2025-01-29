import 'package:flutter/material.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';

import '../utils/app_colors.dart';
import '../utils/styles.dart';
class CustomLabelText extends StatelessWidget {
  const CustomLabelText({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 3.0.res(context)),
        child: Text(label,
            style: Styles.medium16Style(context , size: 15).copyWith(
              color: AppColors.labelTextColor,
            )));
  }
}
