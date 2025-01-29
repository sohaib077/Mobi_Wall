import 'package:flutter/material.dart';
import 'package:swipe_back_detector/swipe_back_detector.dart';

void navigateTo(BuildContext context, Widget page,
    {double x = 1.0, double y = 0.0, bool fade = false}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = Offset(x, y);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SwipeBackDetector(
          child: fade
              ? FadeTransition(
                  opacity: animation,
                  child: child,
                )
              : SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                ),
        );
      },
    ),
  );
}

void navigateAndFinish(BuildContext context, widget,
    {double x = 1.0, double y = 0.0, bool fade = false}) {
  Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final begin = Offset(x, y);
          const end = Offset.zero;
          const curve = Curves.ease;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SwipeBackDetector(
            child: fade
                ? FadeTransition(
                    opacity: animation,
                    child: child,
                  )
                : SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  ),
          );
        },
      ), (route) {
    return false;
  });
}
