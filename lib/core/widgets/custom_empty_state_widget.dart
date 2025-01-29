import 'package:flutter/material.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'empty_lottie_widget.dart';
import 'empty_text_widget.dart';

class CustomEmptyStateWidget extends StatelessWidget {
  const CustomEmptyStateWidget({
    super.key, this.text, this.lottie,
  });

  final String ? text;
  final String ? lottie;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmptyLottieWidget(lottie: lottie),
        SizedBox(height: 10.res(context)),
        EmptyTextWidget(text: text),
      ],
    );
  }
}
