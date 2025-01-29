import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter/widgets.dart';
import 'package:mobi_wall/core/utils/assets_data.dart';
import 'package:mobi_wall/core/utils/size_config.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/features/onboarding/presentation/manager/onboarding_cubit.dart';

class CustomCarouselSlider extends StatelessWidget {
  const CustomCarouselSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const List<String> texts = [
      'Know what your \nchildren are looking for',
      'Speed control \nof devices',
      'Secure browsing \nwith no limits',
    ];
    return CarouselSlider(
      items: [
        _buildItem(AssetsData.onboarding1, texts[0], context),
        _buildItem(AssetsData.onboarding2, texts[1], context),
        _buildItem(AssetsData.onboarding3, texts[2], context),
      ],
      options: CarouselOptions(
        scrollPhysics: const BouncingScrollPhysics(),
        height: SizeConfig.screenHeight * .4,
        // enlargeCenterPage: true,
        enableInfiniteScroll: false,
        viewportFraction: 1,
        onScrolled: (index) {
          OnboardingCubit.get(context).changeIndex(index!);
        },
        onPageChanged: (index, reason) {
          if (index == 2) {
            OnboardingCubit.get(context).changeLetsGo(value: true);
          } else {
            OnboardingCubit.get(context).changeLetsGo(value: false);
          }
        },
      ),
    );
  }

  Widget _buildItem(String image, String text, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FittedBox(
              child: Text(
                text,
                style: Styles.medium25Style(context),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            flex: 3,
            child: Image.asset(
              // height: SizeConfig.screenHeight * .3,
              image,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
