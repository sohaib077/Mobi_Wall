import 'package:flutter/material.dart';

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, size.height); // Start at bottom center
    path.lineTo(size.width, 0); // Draw line to top right
    path.lineTo(0, 0); // Draw line to top left
    path.close(); // Close the path to form a triangle
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
