import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_wall/core/functions/navigation.dart';
import 'package:mobi_wall/core/helpers/cache_helper.dart';
import 'package:mobi_wall/core/utils/constants.dart';
import 'package:mobi_wall/core/utils/size_config.dart';
import 'package:mobi_wall/core/widgets/custom_animated_button.dart';
import 'package:mobi_wall/features/auth/presentation/views/auth_view.dart';
import 'package:mobi_wall/features/onboarding/presentation/manager/onboarding_cubit.dart';
import 'package:mobi_wall/features/onboarding/presentation/views/widgets/custom_carousel_slider.dart';
import 'package:mobi_wall/features/onboarding/presentation/views/widgets/custom_dots_indicator.dart';

import '../../../../core/utils/styles.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(height: 40),
                  const CustomCarouselSlider(),
                  const SizedBox(height: 30),
                  Text(
                    "Unlock your limit with more \nsecure features",
                    style: Styles.regular16Style(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  const CustomDotsIndicator(),
                  const SizedBox(height: 50),
                  if (OnboardingCubit.get(context).letsGo)
                    CustomAnimatedButton(
                      onPressed: () {
                        CacheHelper.saveData(
                                key: Constants.cachedOnboarding, value: false)
                            .then((value) {
                          navigateAndFinish(context, const AuthView());
                        });
                      },
                      text: 'Let’s go',
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
