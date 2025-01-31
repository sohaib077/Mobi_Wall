
import '../utils/constants.dart';
import '../helpers/extensions.dart';

class ErrorModel {
  final String? message;
  final String? code;
  final Map<String, dynamic>? errors;

  ErrorModel({this.message, this.code, this.errors});

  String getErrorsMessage() {
    if (errors.isNullOrEmpty()) {
      return message ?? Constants.unknownError;
    }

    final String errorsMessage = errors!.entries.map(
      (e) {
        return "${e.value['message']}";
      },
    ).join('\n');
    return errorsMessage;
  }
}
