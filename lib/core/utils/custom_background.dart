
// Reusable gradient background
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth,
      height: screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,

          colors: [
            const Color(0xFF231F20),
            const Color(0xFF231F20).withOpacity(1),
          ],
          stops: const [-0.1053, 1.3707],
        ),
      ),
      child: child,
    );
  }
}