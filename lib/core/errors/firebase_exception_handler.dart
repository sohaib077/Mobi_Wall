import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../utils/constants.dart';

abstract class FirebaseExceptionHandler {
  static handleException(FirebaseException e) {
    log("Error From Firebase === ${e.toString()}");
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case "invalid-credential":
          return "Email or password isn't correct.";
        case "email-already-in-use":
          return "Your email is already in use";
        case "invalid-email":
          return "Your email address appears to be malformed.";
        case "wrong-password":
          return "Your password is wrong.";
        case "user-not-found":
          return "User with this email doesn't exist.";
        case "user-disabled":
          return "User with this email has been disabled.";
        case "too-many-requests":
          return "Too many requests. Try again later.";
        case "user-token-expired":
          return "Signing in with Email and Password is not enabled.";
        case "network-request-failed":
          return "No Internet Connection.";
        case "weak-password":
          return "Your password is not strong enough.";
        default:
          return Constants.unknownError;
      }
    } else {
      switch (e.code) {
        case 'aborted':
          return "The operation was aborted. Please try again.";
        case 'already-exists':
          return "The document you are trying to create already exists.";
        case 'cancelled':
          return "The operation was cancelled.";
        case 'data_loss':
          return "Unrecoverable data loss or corruption occurred.";
        case 'deadline_exceeded':
          return "The operation took too long to complete. Please try again.";
        case 'failed_precondition':
          return "The system is not in the required state to perform this operation.";
        case 'internal':
          return "An internal error occurred. Please try again later.";
        case 'invalid_argument':
          return "An invalid argument was provided. Please check your input.";
        case 'not_found':
          return "The requested document was not found.";
        case 'ok':
          return "The operation completed successfully.";
        case 'out_of_range':
          return "The operation was attempted outside the valid range.";
        case 'permission_denied':
          return "You do not have permission to perform this operation.";
        case 'resource_exhausted':
          return "A resource limit has been reached. Please try again later.";
        case 'unauthenticated':
          return "Authentication failed. Please log in and try again.";
        case 'unavailable':
          return "The service is currently unavailable. Please try again later.";
        default:
          return Constants.unknownError;
      }
    }
  }
}
