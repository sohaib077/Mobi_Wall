import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mobi_wall/core/enums/alert_state_enum.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/assets_data.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/core/widgets/custom_animated_container.dart';
import 'package:mobi_wall/core/widgets/custom_back_arrow.dart';
import 'package:mobi_wall/core/widgets/custom_elevated_button.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../manager/otp_cubit.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key, required this.phone});

  final String phone;

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  String otpCode = '1';

  var otpController = TextEditingController();

  @override
  void initState() {
    OtpCubit.get(context).submitPhoneNumber(widget.phone, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: BlocConsumer<OtpCubit, OtpState>(
          listener: (context, state) {
            if (state is PhoneNumberSubmitted) {
              showAlertDialog(context,
                  state: AlertState.success,
                  description: "\nThe code's been sent successfully\n");
            } else if (state is ErrorOccurred) {
              if (state.errorMsg == "verification failed") {
                showAlertDialog(context,
                    state: AlertState.failed,
                    description: "\nSomething went wrong, try again later\n");
              } else if (state.errorMsg.contains("blocked")) {
                showAlertDialog(context,
                    state: AlertState.failed, description: state.errorMsg);
              }
            }
          },
          builder: (context, state) {
            var cubit = OtpCubit.get(context);
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: CustomBackArrow()),
                      SizedBox(
                        height: screenHeight * 0.3,
                        child: Lottie.asset(AssetsData.otpLottie),
                      ),
                      // SizedBox(height: screenHeight * 0.015),
                      SizedBox(
                        width: screenWidth * 0.8,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Phone Number Verification',
                            style: Styles.semiBold20Style(context),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      _buildTitle(screenWidth, context),
                      SizedBox(height: screenHeight * 0.05),
                      _buildPins(context),
                      SizedBox(height: screenHeight * 0.04),
                      _buildResendRow(state, cubit, context),
                      SizedBox(height: screenHeight * 0.01),
                      CustomElevatedButton(
                        loading: cubit.verifyState.isLoading(),
                        text: "VERIFY",
                        onPressed: () {
                          if (state is! Loading) {
                            if (otpCode.length == 6) {
                              cubit.submitOTP(otpCode, context);
                            } else {
                              log('wrong otpCode');
                              showAlertDialog(
                                context,
                                description:
                                    'Please fill up all the cells properly',
                                state: AlertState.failed,
                              );
                            }
                          }
                        },
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      if (state is Loading)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02),
                          // child: linearLoading(screenHeight),
                          child: const LinearProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      SizedBox(height: screenHeight * 0.1),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Row _buildResendRow(OtpState state, OtpCubit cubit, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Didn\'t receive the code? ',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14.sp,
            letterSpacing: 0,
          ),
        ),
        TextButton(
          onPressed: () {
            if (state is! Loading) {
              cubit.submitPhoneNumber(widget.phone, context);
            }
          },
          child: Text(
            'RESEND',
            style: Styles.medium16Style(context, size: 14)
                .copyWith(color: AppColors.primaryColor),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            overlayColor:
                MaterialStateProperty.all(Colors.redAccent.withOpacity(0.1)),
          ),
          onPressed: () {
            if (state is! Loading) {
              otpController.clear();
            }
          },
          child: Text(
            'Clear'.toUpperCase(),
            style: Styles.medium16Style(context, size: 14)
                .copyWith(color: Colors.red),
          ),
        ),
      ],
    );
  }

  PinCodeTextField _buildPins(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: otpController,
      autoFocus: false,
      cursorColor: AppColors.primaryColor,
      keyboardType: TextInputType.number,
      length: 6,
      obscureText: false,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5.r),
        activeBorderWidth: 0,
        inactiveBorderWidth: 0,
        selectedBorderWidth: 0,
        fieldHeight: 50.h,
        fieldWidth: 40.w,
        // fieldWidth: screenWidth/10,
        borderWidth: .5.w,
        activeColor: AppColors.primaryColor.withOpacity(0.4),
        inactiveColor: AppColors.veryDarkBlue.withOpacity(0.2),
        inactiveFillColor: AppColors.textFormFieldFillColor,
        activeFillColor: Colors.white,
        selectedColor: AppColors.primaryColor.withOpacity(0.8),
        selectedFillColor: Colors.white,
      ),
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      onChanged: (value) {
        otpCode = value;
      },
      beforeTextPaste: (text) {
        print("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
    );
  }

  SizedBox _buildTitle(double screenWidth, BuildContext context) {
    return SizedBox(
      width: screenWidth * 0.7,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: RichText(
          text: TextSpan(
              text: 'Enter the code sent to ',
              style: Styles.regular14Style(context)
                  .copyWith(color: AppColors.darkGray),
              children: <TextSpan>[
                TextSpan(
                  text: widget.phone.toString(),
                  style: Styles.semiBold20Style(context, size: 16),
                ),
              ]),
        ),
      ),
    );
  }
}
