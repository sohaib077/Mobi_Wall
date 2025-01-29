import 'package:flutter/material.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/styles.dart';

class SplashLoadingProgress extends StatelessWidget {
  const SplashLoadingProgress({
    super.key,
    required this.progressWidth,
  });

  final double progressWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      width: progressWidth,
      padding: EdgeInsets.only(top: progressWidth == 0 ? 0 : 20.res(context)),
      child: Column(
        children: [
          LinearProgressIndicator(
            minHeight: 4.res(context),
            borderRadius: BorderRadius.circular(2.res(context)),
            // backgroundColor: Colors.transparent,
            color: AppColors.primaryColor,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.only(top: progressWidth == 0 ? 0 : 8.res(context)),
              child: Text("Loading...",
                  style: Styles.regular14Style(context, size: 12)
                      .copyWith(color: AppColors.veryDarkBlue)),
            ),
          ),
        ],
      ),
    );
  }
}
