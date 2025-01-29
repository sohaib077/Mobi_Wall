import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/widgets/custom_bottom_sheet_text_form_field.dart';

import '../utils/constants.dart';
import 'custom_elevated_button.dart';

class PasswordBottomSheet extends StatefulWidget {
  const PasswordBottomSheet(
      {super.key, required this.action, required this.actionTitle});

  final VoidCallback action;
  final String actionTitle;

  @override
  State<PasswordBottomSheet> createState() => _PasswordBottomSheetState();
}

class _PasswordBottomSheetState extends State<PasswordBottomSheet> {
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomBottomSheetTextFormField(
              controller: passwordController,
              hintText: "Enter child's password",
              validator: (String value) {
                if (value.trim().isEmpty) return "Enter a valid password";

                /// uncomment
                /*
                if (value != Constants.childData!.password)
                  return "Wrong password, try again";
                  */
              },
              label: "Password",
            ),
            const SizedBox(height: 30),
            CustomElevatedButton(
              text: widget.actionTitle,
              color: Colors.redAccent,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  widget.action();
                }
              },
            ),
            SizedBox(height: 40.h),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
