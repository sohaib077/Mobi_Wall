import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobi_wall/core/widgets/password_validation_item.dart';

class PasswordValidations extends StatelessWidget {
  final bool hasLowerCase;
  final bool hasUpperCase;
  final bool hasSpecialCharacters;
  // final bool hasNumber;
  final bool hasMinLength;

  const PasswordValidations({
    super.key,
    required this.hasLowerCase,
    required this.hasUpperCase,
    required this.hasSpecialCharacters,
    // required this.hasNumber,
    required this.hasMinLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PasswordValidationItem(
        text:  'At least 1 lowercase letter',
          hasValidated:  hasLowerCase,
        ),
        PasswordValidationItem(
        text:  'At least 1 uppercase letter',
          hasValidated:  hasUpperCase,
        ),
        PasswordValidationItem(
        text:  'At least 1 special character',
          hasValidated:  hasSpecialCharacters,
        ),
        // PasswordValidationRow(
        // text:  'At least 1 number',
        //   hasValidated:  hasNumber,
        // ),
        PasswordValidationItem(
        text:  'At least 8 characters long',
          hasValidated:  hasMinLength,
        ),
      ],
    );
  }
}
