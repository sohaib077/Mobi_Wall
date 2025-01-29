import 'package:flutter/material.dart';

import '../utils/styles.dart';

class CustomAnimatedText extends StatelessWidget {
  const CustomAnimatedText({super.key, required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Text(
        text,
        style: style ?? Styles.semiBold20Style(context, size: 18),
        key: Key(text),
      ),
    );
  }
}
