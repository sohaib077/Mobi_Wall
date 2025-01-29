import 'package:flutter/material.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import '../utils/styles.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.color,
    this.verticalPadding,
    this.overlayColor,
  });

  final void Function()? onPressed;
  final String text;
  final Color? color;
  final Color? overlayColor;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style:
            Styles.customButtonStyle(color: color, overlayColor: overlayColor),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 18.res(context)),
          child: FittedBox(
            child: Text(
              text,
              style: Styles.medium25Style(context, size: 14).copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
