// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../utils/constants.dart';
import 'error_model.dart';
import 'firebase_exception_handler.dart';

abstract class ErrorHandler {
  static ErrorModel handle(dynamic error) {
    log("Error from error handler = ${error.toString()} ");

    if (error is TimeoutException)
      return ErrorModel(message: "Connection timeout.");

    if (error is SocketException)
      return ErrorModel(message: "Check your internet connection.");

    if (error is FirebaseException) {
      return ErrorModel(
        message: FirebaseExceptionHandler.handleException(error),
        code: error.code,
      );
    }

    return ErrorModel(message: Constants.unknownError);
  }
}
