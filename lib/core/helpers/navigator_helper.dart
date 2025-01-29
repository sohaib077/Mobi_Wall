import 'package:flutter/material.dart';

class NavigationHelper {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Navigate to a new screen with a widget page.
  /// Supports passing any data type [T] as the return type.
  static Future<T?> navigateTo<T extends Object?>(
      BuildContext context,
      Widget page,
      ) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Replace the current screen with a new widget page.
  /// Supports passing any data type [T] as the return type.
  static Future<T?> replaceWith<T extends Object?>(
      BuildContext context,
      Widget page,
      ) {
    return Navigator.of(context).pushReplacement<T, T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Navigate to a named route, passing any type of argument.
  static Future<T?> navigateToNamed<T extends Object?>(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.of(context).pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Replace current route with a named route and pass any type of argument.
  static Future<T?> replaceWithNamed<T extends Object?>(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.of(context).pushReplacementNamed<T, T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate back to the previous screen, optionally with a result.
  static void goBack<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }

  /// Clear all previous routes and navigate to a new widget page.
  /// Supports any data type [T] as the return type.
  static Future<T?> navigateAndClearStack<T extends Object?>(
      BuildContext context,
      Widget page,
      ) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (context) => page),
          (route) => false,
    );
  }

  /// Clear all previous routes and navigate to a named route, passing any type of argument.
  static Future<T?> navigateAndClearStackNamed<T extends Object?>(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.of(context).pushNamedAndRemoveUntil<T>(
      routeName,
          (route) => false,
      arguments: arguments,
    );
  }

  /// Convenience method for navigating using the global navigator key, without needing BuildContext.
  /// Allows passing any widget or data type directly.
  static Future<T?>? navigateUsingKey<T extends Object?>(
      Widget page,
      ) {
    return navigatorKey.currentState?.push<T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Replaces the current route using the global navigator key, without needing BuildContext.
  static Future<T?>? replaceUsingKey<T extends Object?>(
      Widget page,
      ) {
    return navigatorKey.currentState?.pushReplacement<T, T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }
  /// Navigate using a custom route, which allows for custom animations.
  static Future<T?> navigateWithCustomRoute<T extends Object?>(
      BuildContext context,
      Route<T> route,
      ) {
    return Navigator.of(context).push<T>(route);
  }
  /// Custom route with a punch (scale) transition animation.
  // static Route createPunchRoute(Widget page) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => page,
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       const beginScale = 0.0;
  //       const endScale = 1.0;
  //       final tween = Tween(begin: beginScale, end: endScale);
  //       final scaleAnimation = animation.drive(tween);
  //
  //       return ScaleTransition(
  //         scale: scaleAnimation,
  //         child: child,
  //       );
  //     },
  //     transitionDuration: const Duration(milliseconds: 400), // Customize duration
  //   );
  // }


  // Great
  // static Route createPunchRoute(Widget child) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => child,
  //     transitionDuration: const Duration(milliseconds: 600),
  //     reverseTransitionDuration: const Duration(milliseconds: 250),
  //     opaque: false,
  //     barrierColor: Colors.black.withOpacity(0.2),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       // Enhanced shake effect parameters
  //       const shakeDistance = 0.08;
  //       const beginOffset = Offset(0.0, 1.0);
  //       const endOffset = Offset.zero;
  //
  //       // Create a more pronounced scroll effect with shake
  //       var openTween = TweenSequence<Offset>([
  //         // Initial fast scroll up
  //         TweenSequenceItem(
  //           tween: Tween(begin: beginOffset, end: Offset(0.0, 0.4))
  //               .chain(CurveTween(curve: Curves.easeOutCubic)),
  //           weight: 40,
  //         ),
  //         // Quick overshoot with shake
  //         TweenSequenceItem(
  //           tween: Tween(begin: Offset(0.0, 0.4), end: Offset(0.0, -0.1))
  //               .chain(CurveTween(curve: Curves.easeOutBack)),
  //           weight: 30,
  //         ),
  //         // Shake back down
  //         TweenSequenceItem(
  //           tween: Tween(begin: Offset(0.0, -0.1), end: Offset(0.0, shakeDistance))
  //               .chain(CurveTween(curve: Curves.bounceOut)),
  //           weight: 20,
  //         ),
  //         // Settle to final position
  //         TweenSequenceItem(
  //           tween: Tween(begin: Offset(0.0, shakeDistance), end: endOffset)
  //               .chain(CurveTween(curve: Curves.easeOutCirc)),
  //           weight: 10,
  //         ),
  //       ]);
  //
  //       // Create the secondary animation for the background
  //       var secondaryTween = Tween<Offset>(
  //         begin: Offset.zero,
  //         end: Offset(0.0, 0.3),
  //       ).chain(CurveTween(curve: Curves.easeInOut));
  //
  //       return Stack(
  //         children: [
  //           // Background slide animation
  //           SlideTransition(
  //             position: animation.drive(secondaryTween),
  //             child: Container(
  //               width: double.infinity,
  //               height: double.infinity,
  //               color: Colors.transparent,
  //             ),
  //           ),
  //           // Main content animation
  //           SlideTransition(
  //             position: animation.drive(openTween),
  //             child: child,
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  static Route createPunchRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: const Duration(milliseconds: 800), // Increased for smoother feel
      reverseTransitionDuration: const Duration(milliseconds: 300),
      opaque: false,
      barrierColor: Colors.black.withOpacity(0.2),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Smoother parameters
        const shakeDistance = 0.04; // Reduced for subtlety
        const beginOffset = Offset(0.0, 1.0);
        const endOffset = Offset.zero;

        // Smoother scroll effect
        var openTween = TweenSequence<Offset>([
          // Initial smooth scroll up
          TweenSequenceItem(
            tween: Tween(begin: beginOffset, end: Offset(0.0, 0.2))
                .chain(CurveTween(curve: Curves.easeOutQuint)), // Smoother curve
            weight: 50,
          ),
          // Gentle overshoot
          TweenSequenceItem(
            tween: Tween(begin: Offset(0.0, 0.2), end: Offset(0.0, -0.05))
                .chain(CurveTween(curve: Curves.easeOutCubic)),
            weight: 25,
          ),
          // Subtle bounce
          TweenSequenceItem(
            tween: Tween(begin: Offset(0.0, -0.05), end: Offset(0.0, shakeDistance))
                .chain(CurveTween(curve: Curves.easeInOutCubic)),
            weight: 15,
          ),
          // Smooth settle
          TweenSequenceItem(
            tween: Tween(begin: Offset(0.0, shakeDistance), end: endOffset)
                .chain(CurveTween(curve: Curves.easeOutCirc)),
            weight: 10,
          ),
        ]);

        // Smoother background movement
        var secondaryTween = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(0.0, 0.15), // Reduced movement for subtlety
        ).chain(CurveTween(curve: Curves.easeOutQuint));

        return Stack(
          children: [
            // Background slide animation
            SlideTransition(
              position: animation.drive(secondaryTween),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
            // Main content animation
            SlideTransition(
              position: animation.drive(openTween),
              child: child,
            ),
          ],
        );
      },
    );
  }
  // used
  // static Route createPunchRoute(Widget child) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => child,
  //     transitionDuration: const Duration(milliseconds: 350),
  //     reverseTransitionDuration: const Duration(milliseconds: 300),
  //     opaque: false,
  //     barrierColor: Colors.black.withOpacity(0.2),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       // Offset for the drag effect, starts near bottom and slightly overshoots
  //       const begin = Offset(0.0, 1.0);
  //       const overshoot = Offset(0.0, -0.05); // Slight overshoot above the top
  //       const end = Offset.zero;
  //
  //       // Define a combined animation with an initial overshoot
  //       var tween = TweenSequence<Offset>([
  //         TweenSequenceItem(tween: Tween(begin: begin, end: overshoot).chain(CurveTween(curve: Curves.easeOutBack)), weight: 80),
  //         TweenSequenceItem(tween: Tween(begin: overshoot, end: end).chain(CurveTween(curve: Curves.easeInOut)), weight: 20),
  //       ]);
  //
  //       // Apply the tween for a dragging effect
  //       var offsetAnimation = animation.drive(tween);
  //
  //       return SlideTransition(
  //         position: offsetAnimation,
  //         child: FadeTransition(
  //           opacity: animation.drive(Tween(begin: 0.4, end: 1.0)), // Quick fade-in
  //           child: child,
  //         ),
  //       );
  //     },
  //   );
  // }

}
