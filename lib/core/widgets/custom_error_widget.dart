import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/assets_data.dart';
class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    this.onPressed,
    this.horizontalPadding,
    this.iconSize,
    this.verticalPadding,
  });

  final void Function()? onPressed;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding ?? width * 0.05,
              vertical: verticalPadding ?? 0,
            ),
            child: Lottie.asset(
              AssetsData.networkErrorLottie,
              width: double.infinity,
              fit: BoxFit.cover,
              repeat: false,
            ),
          ),
          if (onPressed != null)
            IconButton(
              onPressed: onPressed ?? () {},
              icon: Icon(
                Icons.refresh_rounded,
                size: iconSize ?? 50,
                color: Colors.teal,
              ),
            ),
        ],
      ),
    );
  }
}
