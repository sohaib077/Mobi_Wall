import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import '../utils/assets_data.dart';
import '../utils/size_config.dart';
import '../utils/styles.dart';

class CustomElevatedButton extends StatefulWidget {
  const CustomElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.color,
    this.verticalPadding,
    this.overlayColor,
    this.loading = false,
  });

  final void Function()? onPressed;
  final String text;
  final Color? color;
  final Color? overlayColor;
  final double? verticalPadding;
  final bool loading;

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    final double width =
        widget.loading ? SizeConfig.screenWidth * .3 : SizeConfig.screenWidth;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      onEnd: () => setState(() => showLoading = !showLoading),
      width: width,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: Styles.customButtonStyle(
            color: widget.color, overlayColor: widget.overlayColor),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: widget.verticalPadding ?? 18.res(context)),
          child: (showLoading && widget.loading)
              ? loadingWidget()
              : FittedBox(
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

  Widget loadingWidget() {
    return Lottie.asset(AssetsData.threeLoadingDotsLottie,
        width: double.infinity, height:20.res(context));
  }
}
