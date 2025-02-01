import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/utils/constants.dart';
import 'package:mobi_wall/core/helpers/cache_helper.dart';
import 'package:mobi_wall/core/widgets/custom_back_arrow.dart';
import 'package:mobi_wall/core/widgets/custom_animated_button.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:mobi_wall/features/parent/presentation/views/parent_children_view.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/stepper_item.dart';

class ParentView extends StatelessWidget {
  const ParentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              const CustomBackArrow(),
              SizedBox(height: 30.h),
              StepperItem(
                totalSteps: 7,
                stepperLength: 60.h,
                number: '1',
                text:
                    "You must create a child account with a username and password.",
              ),
              StepperItem(
                stepperLength: 100.h,
                number: '2',
                text:
                    "Please use your child's Android device browser to access the link below to download and install the child's app.",
                linkText: "Download MobiWall.app",
              ),
              StepperItem(
                stepperLength: 160.h,
                number: '3',
                text:
                    "You must login from your child's device with the same account you have registered, then choose children's and login with the same username and password which you've created for this child.",
                linkText: "Watch a tutorial",
                totalSteps: 15,
              ),
              SizedBox(height: 40.h),
              Align(
                alignment: Alignment.center,
                child: CustomAnimatedButton(
                  text: "Next",
                  onPressed: () {
                    CacheHelper.saveData(key: Constants.cachedIsParent, value: true);
                    navigateTo(context, const ParentChildrenView());

                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
