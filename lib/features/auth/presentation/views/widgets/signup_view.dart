import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/errors/error_model.dart';
import 'package:mobi_wall/core/helpers/app_regex.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';
import 'package:mobi_wall/core/widgets/custom_animated_container.dart';
import 'package:mobi_wall/core/widgets/custom_elevated_button.dart';
import 'package:mobi_wall/core/widgets/custom_logo.dart';
import 'package:mobi_wall/core/widgets/custom_text_form_field.dart';
import 'package:mobi_wall/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobi_wall/core/widgets/password_validations.dart';
import 'package:mobi_wall/features/auth/presentation/views/widgets/sign_up_text_button.dart';
import 'package:mobi_wall/features/auth/presentation/views/widgets/login_text.dart';

class SignupView extends StatefulWidget {
  const SignupView({
    super.key,
  });

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isObscureText = true;
  bool hasLowerCase = false;
  bool hasUpperCase = false;
  bool hasSpecialCharacters = false;
  bool hasMinLength = false;

  bool autoValidate = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FadeTransition(
          opacity: _animation,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                const CustomLogo(),
                SizedBox(height: 15.h),
                const LoginText(isSignup: true),
                SizedBox(height: 45.h),
                CustomTextFormField(
                  autoValidate: autoValidate,
                  controller: nameController,
                  hintText: "Enter your full name",
                  label: "Full name",
                  validator: (String value) {
                    if (value.isEmpty) return "Enter a valid name";
                  },
                ),
                SizedBox(height: 15.h),
                CustomTextFormField(
                  autoValidate: autoValidate,
                  controller: emailController,
                  hintText: "Enter your email",
                  label: "Email",
                  validator: (String value) {
                    if (value.isEmpty || !AppRegex.isEmailValid(value))
                      return "Enter a valid email";
                  },
                ),
                SizedBox(height: 15.h),
                CustomTextFormField(
                  autoValidate: autoValidate,
                  controller: phoneController,
                  hintText: "Enter your phone number ",
                  label: "Phone number",
                  validator: (String value) {
                    if (value.isEmpty || !AppRegex.isPhoneNumberValid(value))
                      return "Enter a valid phone number";
                  },
                ),
                SizedBox(height: 15.h),
                CustomTextFormField(
                  autoValidate: autoValidate,
                  controller: passwordController,
                  hintText: "Enter your password",
                  label: "Password",
                  obscureText: isObscureText,
                  validator: (String value) {
                    if (value.isEmpty ||
                        !hasLowerCase ||
                        !hasUpperCase ||
                        !hasSpecialCharacters ||
                        !hasMinLength) return "Enter a valid password";
                  },
                  onChange: (value) {
                    setState(() {
                      hasLowerCase = AppRegex.hasLowerCase(value);
                      hasUpperCase = AppRegex.hasUpperCase(value);
                      hasSpecialCharacters =
                          AppRegex.hasSpecialCharacter(value);
                      hasMinLength = AppRegex.hasMinLength(value);
                    });
                  },
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
                ),
                SizedBox(height: 10.h),
                PasswordValidations(
                  hasLowerCase: hasLowerCase,
                  hasUpperCase: hasUpperCase,
                  hasSpecialCharacters: hasSpecialCharacters,
                  hasMinLength: hasMinLength,
                ),
                SizedBox(height: 30.h),
                CustomElevatedButton(
                  text: 'Sign Up',
                  loading: AuthCubit.get(context).registerState.isLoading(),
                  onPressed: () {
                    if (!autoValidate) {
                      setState(() {
                        autoValidate = true;
                      });
                    }
                    if (formKey.currentState!.validate()) {
                      AuthCubit.get(context).register(
                        context,
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        phone: phoneController.text.trim(),
                      );
                    }
                  },
                ),
                SizedBox(height: 25.h),
                const SignUpTextButton(isSignup: true),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
