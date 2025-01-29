import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobi_wall/core/utils/assets_data.dart';
import 'package:mobi_wall/core/utils/styles.dart';

class SlidingWidget extends StatelessWidget {
  const SlidingWidget({
    super.key,
    required this.slidingAnimation,
    this.isText = false,
    this.text,
    this.lottie,
  });

  final Animation<Offset> slidingAnimation;
  final bool isText;
  final String? text;
  final String? lottie;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slidingAnimation,
      builder: (context, _) => SlideTransition(
        position: slidingAnimation,
        child: isText
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  text ?? "",
                  style: Styles.semiBold20Style(context, size: 16),
                  textAlign: TextAlign.center,
                ),
              )
            : Lottie.asset(lottie ?? AssetsData.emptyLottie,
                fit: BoxFit.contain),
      ),
    );
  }
}
