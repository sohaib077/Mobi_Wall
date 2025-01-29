import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import '../../manager/onboarding_cubit.dart';

class CustomDotsIndicator extends StatelessWidget {
  const CustomDotsIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return DotsIndicator(
          // reversed: true,
          dotsCount: 3,
          position: OnboardingCubit
              .get(context)
              .currentIndex,
          decorator: DotsDecorator(
            color: const Color(0xffCFD9E3),
            activeColor: AppColors.primaryColor,
            size:  const Size.fromRadius(5),
            activeSize: const Size(15, 10),
            activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        );
      },
    );
  }
}
