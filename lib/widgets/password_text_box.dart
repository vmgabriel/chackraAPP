import 'package:flutter/material.dart';
import 'package:argos_home/l10n/app_localizations.dart';

// Styles
import 'package:argos_home/styles.dart' as styles;

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final List<Function(String? value, BuildContext context)> validators;
  final String Function(BuildContext context) labelTextContext;
  final String Function(BuildContext context) hintTextContext;

  const PasswordInputField({
    super.key,
    required this.controller,
    required this.validators,
    required this.labelTextContext,
    required this.hintTextContext,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      decoration: _buildInputDecoration(
        labelText: widget.labelTextContext(context),
        hintText: widget.hintTextContext(context),
      ),
      style: const TextStyle(color: styles.kPrimaryColor),
      validator: (value) {
        for (Function(String? value, BuildContext context) validator in widget.validators) {
          var response = validator(value, context);
          if (response != null) {
            return response;
          }
        }
        return null;
      },
    );
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required String hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: const TextStyle(color: styles.kPrimaryColor),
      hintStyle: TextStyle(color: styles.kHintColor.withOpacity(0.8)),
      filled: true,
      fillColor: styles.kWhiteColor.withOpacity(0.8),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18.0,
        horizontal: 12.0,
      ),
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
      suffixIcon: IconButton(
        icon: Icon(
          _isObscured ? Icons.visibility_off : Icons.visibility,
          color: styles.kPrimaryColor,
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      ),
    );
  }
}
