import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobi_wall/core/enums/alert_state_enum.dart';
import 'package:mobi_wall/core/enums/method_state_enum.dart';
import 'package:mobi_wall/core/helpers/cache_helper.dart';
import 'package:mobi_wall/core/utils/constants.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:mobi_wall/features/parent/presentation/views/parent_view.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  static OtpCubit get(context) => BlocProvider.of(context);

  String? verificationId;
  String? code;
  BuildContext? context;

  Future<void> submitPhoneNumber(
      String phoneNumber, BuildContext context) async {
    emit(Loading());
    this.context = context;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+2$phoneNumber",
      timeout: const Duration(seconds: 14),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      autoRetrievedSmsCodeForTesting: code,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    await signIn(credential, context);
  }

  void verificationFailed(FirebaseAuthException error) {
    log('Verification Failed : ${error.toString()}');
    emit(ErrorOccurred(
        errorMsg: error.toString().contains("too-many-requests")
            ? "We have blocked all requests from this device due to unusual activity. Try again later."
            : "verification failed"));
  }

  void codeSent(String verificationId, int? resendToken) {
    log('codeSent + code $code ');
    this.verificationId = verificationId;
    log("verification id : ");
    log(this.verificationId.toString());
    emit(PhoneNumberSubmitted());
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    log('codeAutoRetrievalTimeout');
  }

  MethodState verifyState = MethodState.init;

  Future<void> submitOTP(String otpCode, context) async {
    verifyState = MethodState.loading;
    emit(OtpCodeVerifyingLoading());
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpCode,
      );
      await signIn(credential, context);
    } catch (error) {
      verifyState = MethodState.init;

      showAlertDialog(context,
          state: AlertState.failed, description: "Wrong code");
      emit(ErrorOccurred(errorMsg: error.toString()));
    }
    // print('sms code from credential ${credential.smsCode}');
    // print('token from credential ${credential.token}');
  }

  Future<void> signIn(PhoneAuthCredential credential, context) async {
    log("SIGNING IN");
    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        verifyState = MethodState.success;
        emit(PhoneOTPVerified());
        Future.delayed(const Duration(milliseconds: 500), () {
          verifyState = MethodState.init;
          emit(PhoneOTPVerified());
          CacheHelper.saveData(key: Constants.cachedOtp, value: false);
          Constants.otp = false;
          Navigator.pop(context);
          navigateTo(context, const ParentView());
        });
      });
    } catch (error) {
      verifyState = MethodState.init;

      print(error.toString());
      if (verificationId == null) {
        Navigator.pop(context);
      }
      showAlertDialog(context,
          state: AlertState.failed, description: "Wrong code");
      emit(ErrorOccurred(errorMsg: error.toString()));
    }
  }
}
