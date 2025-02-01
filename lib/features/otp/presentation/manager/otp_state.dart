part of 'otp_cubit.dart';

@immutable
abstract class OtpState {}

class OtpInitial extends OtpState {}

class Loading extends OtpState {}

class ErrorOccurred extends OtpState {
  final String errorMsg;

  ErrorOccurred({required this.errorMsg});
}

class PhoneNumberSubmitted extends OtpState{}

class PhoneOTPVerified extends OtpState{}
class OtpCodeVerifyingLoading extends OtpState{}




