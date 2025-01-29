import 'package:flutter/material.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
class CustomLoadingPage extends StatelessWidget {
  const CustomLoadingPage({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          6,
          (index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10.res(context)),
            child: shimmerLoadingContainer(
              height: height,
              width: width,
            ),
          ),
        ),
      ),
    );
  }
}
