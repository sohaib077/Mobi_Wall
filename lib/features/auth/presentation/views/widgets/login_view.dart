import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/helpers/app_regex.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';
import 'package:mobi_wall/core/widgets/custom_elevated_button.dart';
import 'package:mobi_wall/core/widgets/custom_logo.dart';
import 'package:mobi_wall/core/widgets/custom_text_form_field.dart';
import 'package:mobi_wall/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobi_wall/features/auth/presentation/views/widgets/sign_up_text_button.dart';
import 'package:mobi_wall/features/auth/presentation/views/widgets/login_text.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isObscureText = true;
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: formKey,
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomLogo(),
                SizedBox(height: 20.h),
                const LoginText(),
                SizedBox(height: 45.h),
                CustomTextFormField(
                  autoValidate: autoValidate,
                  controller: emailController,
                  hintText: "Enter your email",
                  label: "Email",
                  validator: (String value) {
                    if (value.isEmpty || !AppRegex.isEmailValid(value)) {
                      return "Enter a valid email";
                    }
                  },
                ),
                SizedBox(height: 15.h),
                CustomTextFormField(
                  autoValidate: autoValidate,
                  controller: passwordController,
                  hintText: "Enter your password",
                  label: "Password",
                  validator: (String value) {
                    if (value.isEmpty) return "Enter a valid password";
                  },
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
                ),
                SizedBox(height: 45.h),
                CustomElevatedButton(
                  text: 'Sign In',
                  loading:  AuthCubit.get(context).loginState.isLoading(),
                  onPressed: () {
                    if (!autoValidate) {
                      setState(() {
                        autoValidate = true;
                      });
                    }
                    if (formKey.currentState!.validate()) {
                      AuthCubit.get(context).login(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                    }
                  },
                ),
                SizedBox(height: 25.h),
                const SignUpTextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
