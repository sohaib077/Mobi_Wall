import 'package:flutter/material.dart';
import 'package:mobi_wall/core/helpers/cache_helper.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/background_services.dart';
import 'package:mobi_wall/core/utils/constants.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/core/widgets/custom_card.dart';

class HideAppCard extends StatefulWidget {
  const HideAppCard({
    super.key,
  });

  @override
  State<HideAppCard> createState() => _HideAppCardState();
}

class _HideAppCardState extends State<HideAppCard> {
  bool on = Constants.iconHided;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Row(children: [
        Expanded(
          child: Text(
            "Hide app's icon",
            style: Styles.medium25Style(context, size: 16)
                .copyWith(color: Colors.black, letterSpacing: 1),
          ),
        ),
        if (loading)
          const CircularProgressIndicator(color: AppColors.primaryColor),
        if (!loading)
          Switch(
              splashRadius: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              trackColor:WidgetStatePropertyAll(on
                  ? AppColors.primaryColor
                  : const Color(0xff00091F).withOpacity(0.15)),
              activeColor: const Color(0xffF7F7F7),
              trackOutlineColor:const WidgetStatePropertyAll(Colors.transparent),
              inactiveThumbColor: const Color(0xffF7F7F7),
              value: on,
              onChanged: (value) {
                setState(() {
                  loading = true;
                });
                if (on) {
                  BackgroundServices.showAppIcon().then((value) {
                    CacheHelper.saveData(
                        key: Constants.cachedIconHided, value: false);
                    Constants.iconHided = false;
                    setState(() {
                      on = Constants.iconHided;
                      loading = false;
                    });
                  });
                } else {
                  BackgroundServices.hideAppIcon().then((value) {
                    CacheHelper.saveData(
                        key: Constants.cachedIconHided, value: true);
                    Constants.iconHided = true;
                    setState(() {
                      on = Constants.iconHided;
                      loading = false;
                    });
                  });
                }
              }),
      ]),
    );
  }
}
