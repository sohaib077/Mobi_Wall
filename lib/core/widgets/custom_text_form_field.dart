import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import '../utils/app_colors.dart';
import '../utils/styles.dart';
import 'custom_label_text.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.obscureText,
    this.keyboardType = TextInputType.text,
    this.label,
    required this.validator,
    this.enabled,
    this.labelColor,
    this.suffixIcon,
    this.onChange,
    this.autoValidate = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final String? label;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) CustomLabelText(label: label!),
        // SizedBox(height: 5.h),
        TextFormField(
          autovalidateMode: autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          enabled: enabled ?? true,
          obscureText: obscureText ?? false,
          keyboardType: keyboardType,
          controller: controller,
          style: Styles.medium16Style(context, size: 16),
          validator: (value) => validator(value),
          onChanged: onChange,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 14.sp,
                color: AppColors.labelTextColor.withOpacity(0.8),
                fontWeight: FontWeight.w300),
            fillColor: AppColors.textFormFieldFillColor,
            filled: true,
            focusedBorder: focusedBorder(),
            enabledBorder: enabledBorder(),
            errorBorder: errorBorder(),
            focusedErrorBorder: focusedErrorBorder(),
            border: enabledBorder(),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder errorBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(8.r),
    );
  }

  OutlineInputBorder focusedErrorBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(8.r),
    );
  }

  // OutlineInputBorder border() {
  //   return OutlineInputBorder(
  //     borderSide: const BorderSide(color: Colors.red, width: 0),
  //     borderRadius: BorderRadius.circular(8.r),
  //   );
  // }

  OutlineInputBorder focusedBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryColor.withOpacity(0.2)),
      borderRadius: BorderRadius.circular(8.r),
    );
  }

  OutlineInputBorder enabledBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.textFormFieldFillColor),
      borderRadius: BorderRadius.circular(8.r),
    );
  }

  OutlineInputBorder disabledBorder(Color? borderColor) {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primaryColor),
      borderRadius: BorderRadius.circular(8.r),
    );
  }
}
