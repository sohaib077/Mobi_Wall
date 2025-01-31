import 'package:flutter/material.dart';
import 'package:mobi_wall/core/functions/unfocus.dart';

class Unfocus extends StatelessWidget {
  const Unfocus({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocus(context),
      child: child,
    );
  }
}
