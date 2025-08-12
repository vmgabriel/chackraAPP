import 'package:flutter/material.dart';

// utils
import 'package:argos_home/styles.dart' as styles;


class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String Function(BuildContext context) labelTextContext;
  final String Function(BuildContext context) hintTextContext;

  const SearchField({
    super.key,
    required this.controller,
    required this.labelTextContext,
    required this.hintTextContext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: _buildInputDecoration(labelText: labelTextContext(context), hintText: hintTextContext(context)),
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String labelText, required String hintText}) {
    return InputDecoration(
      prefixIcon: const Icon(Icons.search),
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