import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mobi_wall/core/utils/assets_data.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';
import 'package:mobi_wall/core/utils/size_config.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/core/widgets/custom_back_arrow.dart';
import 'package:mobi_wall/core/widgets/custom_elevated_button.dart';
import 'package:mobi_wall/core/widgets/custom_text_form_field.dart';
import '../../../../core/functions/unfocus.dart';
import '../manager/children_cubit/children_cubit.dart';

class ChildrenLoginView extends StatefulWidget {
  const ChildrenLoginView({
    super.key,
  });

  @override
  State<ChildrenLoginView> createState() => _ChildrenLoginViewState();
}

class _ChildrenLoginViewState extends State<ChildrenLoginView> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isObscureText = true;
  bool autoValidate = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChildrenCubit(),
      child: GestureDetector(
        onTap: () => unfocus(context),
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: BlocBuilder<ChildrenCubit, ChildrenState>(
                    builder: (context, state) {
                      return Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10.h),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: CustomBackArrow()),
                          Lottie.asset(AssetsData.childLottie,
                              height: SizeConfig.screenHeight * 0.15),
                          SizedBox(height: 10.h),
                          Text(
                            "Login now\nto access your child data",
                            style: Styles.semiBold20Style(context, size: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 45.h),
                          CustomTextFormField(
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
                          CustomTextFormField(
                            autoValidate: autoValidate,
                            controller: passwordController,
                            hintText: "Enter your child password",
                            label: "Password",
                            validator: (String value) {
                              if (value.isEmpty)
                                return "Enter a valid password";
                            },
                            obscureText: isObscureText,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isObscureText = !isObscureText;
                                });
                              },
                              child: Icon(
                                isObscureText
                                    ? IconBroken.Hide
                                    : IconBroken.Show,
                              ),
                            ),
                          ),
                          SizedBox(height: 45.h),
                          CustomElevatedButton(
                            loading: ChildrenCubit.get(context).loginChildState.isLoading(),
                            text: 'Login',
                            onPressed: () {
                              if (!autoValidate) {
                                setState(() {
                                  autoValidate = true;
                                });
                              }
                              if (formKey.currentState!.validate()) {
                                ChildrenCubit.get(context).loginChild(
                                  context,
                                  username: usernameController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              }
                            },
                          ),
                          SizedBox(height: 25.h),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
