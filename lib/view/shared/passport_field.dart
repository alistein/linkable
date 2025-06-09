import 'package:flutter/material.dart';
import 'package:linkable/utils/theme/app_colors.dart';

class PasswordField extends StatelessWidget {
  final bool isVisible;
  final VoidCallback toggleVisibility;
  final FormFieldValidator? validator;
  final TextEditingController? controller;
  final String hintText;

  const PasswordField({
    super.key, 
    required this.isVisible, 
    required this.toggleVisibility, 
    this.validator, 
    this.controller,
    this.hintText = 'Password',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: !isVisible,
      onTapOutside: (event) {
        // Unfocus when tapping outside the text field
        FocusScope.of(context).unfocus();
      },
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: LightColors.primary[600],
        height: 1.5,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: LightColors.mutedText,
        ),
        filled: true,
        fillColor: LightColors.input,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: LightColors.border,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: LightColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: LightColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        errorStyle: TextStyle(
          fontSize: 13,
          color: Colors.red.shade600,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: LightColors.mutedText,
            size: 20,
          ),
          onPressed: toggleVisibility,
          splashRadius: 20,
        ),
      ),
    );
  }
}