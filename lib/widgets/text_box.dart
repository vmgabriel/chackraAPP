import 'package:flutter/material.dart';

// utils
import 'package:argos_home/styles.dart' as styles;


class InputField extends StatelessWidget {
  final TextEditingController controller;
  final List<Function(String? value, BuildContext context)> validators;
  final TextInputType textInputType;
  final String Function(BuildContext context) labelTextContext;
  final String Function(BuildContext context) hintTextContext;

  const InputField({
    super.key,
    required this.controller,
    required this.validators,
    required this.textInputType,
    required this.labelTextContext,
    required this.hintTextContext,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      decoration: _buildInputDecoration(
        labelText: labelTextContext(context),
        hintText: hintTextContext(context),
      ),
      style: const TextStyle(color: styles.kPrimaryColor),
      validator: (value) {
        for (Function(String? value, BuildContext context) validator in validators) {
          var response = validator(value, context);
          if (response != null) {
            return response;
          }
        }
        return null;
      },
    );
  }

  InputDecoration _buildInputDecoration({required String labelText, required String hintText}) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: const TextStyle(color: styles.kPrimaryColor),
      hintStyle: TextStyle(color: styles.kHintColor.withOpacity(0.8)),
      filled: true,
      fillColor: styles.kWhiteColor.withOpacity(0.8),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: styles.kHintColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: styles.kHintColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: styles.kPrimaryColor, width: 2.0),
      ),
    );
  }
}