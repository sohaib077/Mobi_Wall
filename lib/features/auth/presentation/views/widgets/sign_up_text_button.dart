import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/features/auth/presentation/manager/auth_cubit.dart';

class SignUpTextButton extends StatelessWidget {
  const SignUpTextButton({
    super.key,
    this.isSignup = false,
  });

  final bool isSignup;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        log("message");
        AuthCubit.get(context).changeSignInView(value: isSignup );
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: isSignup
                  ? "Already have an account?"
                  : 'Don’t have an account?',
              style: Styles.regular16Style(context, size: 14),
            ),
            TextSpan(
              text: isSignup ? " Sign in" : ' Sign Up',
              style: Styles.medium25Style(context, size: 14)
                  .copyWith(color: AppColors.veryDarkBlue),
            ),
          ],
        ),
      ),
    );
  }
}
