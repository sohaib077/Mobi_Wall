import 'package:flutter/material.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/styles.dart';

class CustomBottomSheetTextFormField extends StatelessWidget {
  const CustomBottomSheetTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText,
    this.keyboardType = TextInputType.text,
    required this.label,
    required this.validator,
    this.enabled,
    this.labelColor,
    this.suffixIcon,
    this.onChange,
    this.autoValidate = false,
  });

  final TextEditingController controller;
  final String hintText;
  final String label;
  final bool? obscureText;
  final TextInputType keyboardType;
  final Function validator;
  final bool? enabled;
  final Color? labelColor;
  final Widget? suffixIcon;
  final void Function(String)? onChange;
  final bool autoValidate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autoValidate
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      enabled: enabled ?? true,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      controller: controller,
      style: Styles.medium25Style(context, size: 14),
      validator: (value) => validator(value),
      onChanged: onChange,
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 14.res(context), vertical: 20.res(context)),
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: Styles.regular14Style(context),
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: 14.res(context),
            color: AppColors.labelTextColor.withOpacity(0.8),
            fontWeight: FontWeight.w300),
        fillColor: AppColors.textFormFieldFillColor,
        filled: true,
        focusedBorder: customBorder(context, AppColors.primaryColor.withOpacity(0.4)),
        enabledBorder: customBorder(context,  AppColors.primaryColor.withOpacity(0.1)),
        errorBorder: customBorder(context,  Colors.red.withOpacity(0.3)),
        focusedErrorBorder: customBorder(context,  Colors.red.withOpacity(0.5)),
        border: customBorder(context,  AppColors.primaryColor.withOpacity(0.1)),
      ),
    );
  }

  OutlineInputBorder customBorder(BuildContext context,Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(8.res(context)),
    );
  }
}
