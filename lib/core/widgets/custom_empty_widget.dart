import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/assets_data.dart';
class CustomEmptyWidget extends StatelessWidget {
  const CustomEmptyWidget({
    super.key,
    this.box = false,
    this.vPadding,
    this.hPadding,
  });

  final bool box;
  final double? vPadding;
  final double? hPadding;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: hPadding ?? width * 0.1,
          vertical: vPadding ?? height * 0.1,
        ),
        child: Lottie.asset(
          box ? AssetsData.emptyBoxLottie : AssetsData.emptyLottie,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
