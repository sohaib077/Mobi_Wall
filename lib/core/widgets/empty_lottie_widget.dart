import 'package:flutter/material.dart';

import '../utils/assets_data.dart';
import 'sliding_widget.dart';

class EmptyLottieWidget extends StatefulWidget {
  const EmptyLottieWidget({super.key, this.lottie});

  final String? lottie;

  @override
  State<EmptyLottieWidget> createState() => _EmptyLottieWidgetState();
}

class _EmptyLottieWidgetState extends State<EmptyLottieWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;

  @override
  void initState() {
    initSlidingAnimation();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: SlidingWidget(
          slidingAnimation: slidingAnimation,
          lottie: widget.lottie,
        ),
      ),
    );
  }

  void initSlidingAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    slidingAnimation =
        Tween<Offset>(begin: const Offset(0, -2), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: animationController,
      curve: widget.lottie == AssetsData.emptyBoxLottie
          ? Curves.bounceOut
          : Curves.linearToEaseOut,
    ));

    animationController.forward();
  }
}
