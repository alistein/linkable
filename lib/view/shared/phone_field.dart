import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneField extends StatelessWidget {
  final String hintText;
  final FormFieldValidator? validator;
  final dynamic controller;
  final TextInputAction? inputAction;
  
  const PhoneField({
    super.key, 
    required this.hintText, 
    this.validator, 
    required this.controller, 
    this.inputAction
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => IntlPhoneField(
      validator: validator,
      autovalidateMode: AutovalidateMode.onUnfocus,
      disableLengthCheck: false,
      showDropdownIcon: true,
      initialCountryCode: controller?.selectedCountry.value,
      initialValue: controller?.phoneNumber.value,
      textInputAction: inputAction,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: LightColors.primary[600],
        height: 1.5,
      ),
      dropdownTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: LightColors.primary[600],
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: LightColors.mutedText,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
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
      ),
      flagsButtonPadding: const EdgeInsets.only(left: 12, right: 8),
      dropdownIconPosition: IconPosition.trailing,
      dropdownIcon: Icon(
        Icons.keyboard_arrow_down,
        color: LightColors.mutedText,
        size: 20,
      ),
      onChanged: (phone) {
        controller?.updatePhoneNumber(phone.number);
      },
      onCountryChanged: (country) {
        controller?.changeCountryCode(country.dialCode);
        controller?.changeCountry(country.code);
      },
    ));
  }
}