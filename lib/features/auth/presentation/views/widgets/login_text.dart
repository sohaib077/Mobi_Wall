import 'package:flutter/material.dart';
import 'package:mobi_wall/core/utils/styles.dart';

class LoginText extends StatelessWidget {
  const LoginText({
    super.key,
    this.isSignup = false,
  });

  final bool isSignup;

  @override
  Widget build(BuildContext context) {
    return Text(
      isSignup
          ? "Sign up now to access all firewall\nfeatures to protect your children's"
          : "Sign in now to access all firewall\nfeatures to protect your children's",
      style: Styles.regular14Style(context),
      textAlign: TextAlign.center,
    );
  }
}
