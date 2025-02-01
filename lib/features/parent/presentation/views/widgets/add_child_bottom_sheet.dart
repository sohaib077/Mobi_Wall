import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/helpers/app_regex.dart';
import 'package:mobi_wall/core/widgets/custom_animated_container.dart';
import 'package:mobi_wall/core/widgets/custom_bottom_sheet_text_form_field.dart';
import 'package:mobi_wall/core/widgets/custom_elevated_button.dart';
import 'package:mobi_wall/core/widgets/password_validations.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';
import 'package:mobi_wall/features/parent/presentation/manager/parent_cubit.dart';

class AddChildBottomSheet extends StatefulWidget {
  const AddChildBottomSheet({
    super.key,
  });

  @override
  State<AddChildBottomSheet> createState() => _AddChildBottomSheetState();
}

class _AddChildBottomSheetState extends State<AddChildBottomSheet> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isObscureText = true;
  bool hasMinLength = false;
  bool autoValidate = false;

  bool hasLowerCase = false;
  bool hasUpperCase = false;
  bool hasSpecialCharacters = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentCubit, ParentState>(
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40.h),
                CustomBottomSheetTextFormField(
                  autoValidate: autoValidate,
                  controller: usernameController,
                  hintText: "Enter your child username",
                  label: "Username",
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Enter a valid username";
                    }
                  },
                ),
                SizedBox(height: 25.h),
                CustomBottomSheetTextFormField(
                  autoValidate: autoValidate,
                  controller: passwordController,
                  hintText: "Enter your child password",
                  label: "Password",
                  obscureText: isObscureText,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscureText = !isObscureText;
                      });
                    },
                    child: Icon(
                      isObscureText ? IconBroken.Hide : IconBroken.Show,
                    ),
                  ),
                  onChange: (value) {
                    setState(() {
                      hasLowerCase = AppRegex.hasLowerCase(value);
                      hasUpperCase = AppRegex.hasUpperCase(value);
                      hasSpecialCharacters =
                          AppRegex.hasSpecialCharacter(value);
                      hasMinLength = AppRegex.hasMinLength(value);
                    });
                  },
                  validator: (String value) {
                    if (value.isEmpty ||
                        !hasLowerCase ||
                        !hasUpperCase ||
                        !hasSpecialCharacters ||
                        !hasMinLength) return "Enter a valid password";
                  },
                ),
                SizedBox(height: 15.h),
                PasswordValidations(
                  hasLowerCase: hasLowerCase,
                  hasUpperCase: hasUpperCase,
                  hasSpecialCharacters: hasSpecialCharacters,
                  hasMinLength: hasMinLength,
                ),
                SizedBox(height: 40.h),
                CustomAnimatedContainer(
                  state: ParentCubit.get(context).addChildState,
                  child: CustomElevatedButton(
                    text: 'Add',
                    onPressed: () {
                      if (!autoValidate) {
                        setState(() {
                          autoValidate = true;
                        });
                      }
                      if (formKey.currentState!.validate()) {
                        ParentCubit.get(context).addChild(
                          context,
                          username: usernameController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 40.h),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
