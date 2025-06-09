import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final List<String> options;
  final String? groupValue;
  final ValueChanged<String> onChanged;
  final String errorMessage;

  const CustomRadioButton({
    super.key,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    this.errorMessage = "Please select an option",
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) {
        if (groupValue == null || groupValue!.isEmpty) {
          return errorMessage; // Show validation error if nothing is selected
        }
        return null;
      },
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              children: options.map((option) {
                return InkWell(
                  onTap: () {
                    onChanged(option);
                    field.didChange(option); // Update FormField state
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: groupValue, // Uses directly passed groupValue
                        onChanged: (val) {
                          onChanged(val!);
                          field.didChange(val); // Update FormField state
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(option,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 5),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
          ],
        );
      },
    );
  }
}
