import 'package:flutter/material.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/features/home/presentation/views/home_view.dart';

import '../functions/navigation.dart';
import '../helpers/cache_helper.dart';
import '../utils/constants.dart';
import '../utils/icon_broken.dart';
import '../utils/styles.dart';
import 'shared_methods.dart';

class CustomBackArrow extends StatelessWidget {
  const CustomBackArrow({
    super.key,
    this.backText = true,
    this.backToHome = false,
  });

  final bool backText;
  final bool backToHome;

  @override
  Widget build(BuildContext context) {
    return backText
        ? InkWell(
            onTap: () {
              if (backToHome) {
                CacheHelper.removeData(Constants.cachedChild);
                navigateAndFinish(context, const HomeView(), x: -1, y: 0);
              } else {
                Navigator.pop(context);
              }
            },
            borderRadius: BorderRadius.circular(4.res(context)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  IconBroken.Arrow___Left_2,
                  size: 30.res(context),
                  color: const Color(0xff6B7280),
                ),
                SizedBox(width: 5.res(context)),
                Text(
                  backToHome ? "Home" : "Back",
                  style: Styles.regular16Style(context)
                      .copyWith(color: const Color(0xff6B7280)),
                ),
                SizedBox(width: 5.res(context)),
              ],
            ),
          )
        : InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            customBorder: const CircleBorder(),
            child: Icon(
              IconBroken.Arrow___Left_2,
              size: 30.res(context),
            ),
          );
  }
}
