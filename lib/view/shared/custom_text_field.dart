import 'package:flutter/material.dart';
import 'package:linkable/utils/app_decorations.dart';
import 'package:linkable/utils/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final FormFieldValidator? validator;
  final TextEditingController? controller;
  final TextInputAction? inputAction;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.validator,
    this.controller,
    this.inputAction,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard and unfocus when tapping outside
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: TextFormField(
        keyboardType: keyboardType ?? TextInputType.text,
        controller: controller,
        validator: validator,
        textInputAction: inputAction,
        obscureText: obscureText,
        focusNode: focusNode,
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
            color:  LightColors.mutedText,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor:  LightColors.input,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color:  LightColors.border,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color:  LightColors.border,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color:  LightColors.primary,
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
        ),
      ),
    );
  }
}