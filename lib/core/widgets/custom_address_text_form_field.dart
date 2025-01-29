import 'package:flutter/material.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';

import '../utils/app_colors.dart';
import '../utils/styles.dart';

class CustomAddressTextFormField extends StatelessWidget {
  const CustomAddressTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.obscureText,
    this.keyboardType = TextInputType.text,
    required this.label,
    this.enabled,
    this.labelColor,
    this.suffixIcon,
    this.validator,
  });

  final TextEditingController? controller;
  final String hintText;
  final String label;
  final bool? obscureText;
  final TextInputType keyboardType;
  final bool? enabled;
  final Color? labelColor;
  final Widget? suffixIcon;

  final Function? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled ?? true,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      controller: controller,
      maxLines: 2,
      minLines: 1,
      validator: validator == null ? (value) {} : (value) => validator!(value),
      style: Styles.regular14Style(context)
          .copyWith(color: AppColors.labelTextColor),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.res(context), vertical: 18.res(context)),
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: Styles.semiBold20Style(context, size: 16)
            .copyWith(height: 3.res(context), letterSpacing: 3.res(context)),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14.res(context),
          color: AppColors.labelTextColor.withOpacity(0.8),
          fontWeight: FontWeight.w300,
        ),
        focusedBorder: customBorder(context, AppColors.primaryColor.withOpacity(0.5)),
        enabledBorder: customBorder(context, AppColors.primaryColor.withOpacity(0.5)),
        disabledBorder: customBorder(context, AppColors.primaryColor.withOpacity(0.4)),
        errorBorder: customBorder(context, Colors.red.withOpacity(0.3)),
        focusedErrorBorder: customBorder(context, Colors.red.withOpacity(0.2)),
        border: customBorder(context, AppColors.primaryColor.withOpacity(0.5)),
      ),
    );
  }

  OutlineInputBorder customBorder(BuildContext context , Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(8.res(context)),
    );
  }
}
