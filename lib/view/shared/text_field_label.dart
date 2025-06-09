
import 'package:flutter/material.dart';

class TextFieldLabel extends StatelessWidget {
  final String label;
  final bool isBold;
  final double topMargin;
  const TextFieldLabel(
      {super.key,
      required this.label,
      this.isBold = true,
      this.topMargin = 15});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topMargin, bottom: 5),
      child: Text(
        label,
        style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 16),
      ),
    );
  }
}