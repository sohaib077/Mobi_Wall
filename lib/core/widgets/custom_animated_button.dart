import 'package:flutter/material.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/constants.dart';

import '../utils/size_config.dart';
import '../utils/styles.dart';

class CustomAnimatedButton extends StatefulWidget {
  const CustomAnimatedButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  final String text;
  final void Function()? onPressed;

  @override
  State<CustomAnimatedButton> createState() => _CustomAnimatedButtonState();
}

class _CustomAnimatedButtonState extends State<CustomAnimatedButton> {
  double width = 50;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        width = SizeConfig.screenWidth * 0.8;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: width,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(horizontal: 15.res(context)),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: Styles.customButtonStyle(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18.res(context)),
          child: FittedBox(
            child: Text(
              widget.text,
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
