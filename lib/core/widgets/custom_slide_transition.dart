import 'package:flutter/material.dart';

class CustomSlideTransition extends StatefulWidget {
  const CustomSlideTransition(
      {super.key, required this.child, required this.index});

  final Widget child;
  final int index;

  @override
  State<CustomSlideTransition> createState() => _CustomSlideTransitionState();
}

class _CustomSlideTransitionState extends State<CustomSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<Offset>(
            begin: Offset(
                0,
                (widget.index == 0)
                    ? widget.index.toDouble() + .5
                    : widget.index.toDouble()),
            end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: animation, child: widget.child);
  }
}
