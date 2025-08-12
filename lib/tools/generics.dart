import 'package:flutter/material.dart';

// Validator Composer
String? Function(String? value, BuildContext context) wrapAndCheckValidation(
    bool Function(String? value) validator,
    String Function(BuildContext context) response,
    ) {
  return (String? value, BuildContext context) {
    if (validator(value)) {
      return response(context);
    }
    return null;
  };
}


// Validator
bool Function(String?) itNotMayBeClear = (String? value) => value == null || value.isEmpty;
bool Function(String?) itMayBeAEmail = (String? value) => !RegExp(r'\S+@\S+\.\S+').hasMatch(value!);
bool Function(String?) itMayHaveAtLeast6Characters = (String? value) => value!.length < 6;
bool Function(String?) itMayNotHaveSpaces = (String? value) => value!.contains(' ');
bool Function(String?) itMayNotHaveSpecialCharacters = (String? value) => !RegExp(r'^[a-zA-z0-9_@.]*$').hasMatch(value!);
bool Function(String?) itMayBeNumber = (String? value) => !RegExp(r'^[0-9]*$').hasMatch(value!);