import 'package:flutter/material.dart';
import 'package:mobi_wall/core/widgets/sliding_widget.dart';

class EmptyTextWidget extends StatefulWidget {
  const EmptyTextWidget({super.key, this.text});

  final String? text;

  @override
  State<EmptyTextWidget> createState() => _EmptyTextWidgetState();
}

class _EmptyTextWidgetState extends State<EmptyTextWidget>
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
      child: SlidingWidget(
          slidingAnimation: slidingAnimation, isText: true, text: widget.text),
    );
  }

  void initSlidingAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    slidingAnimation =
        Tween<Offset>(begin: const Offset(-5, 0), end: Offset.zero)
            .animate(animationController);

    animationController.forward();
    // slidingAnimation.addListener(() {
    //   setState(() {});
    // });
  }
}
