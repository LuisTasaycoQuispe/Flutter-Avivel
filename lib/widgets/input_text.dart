import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InputText extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final bool obscureText, borderEnabled;
  final double fontSize;
  final void Function(String text) onChanged;

  const InputText({
    Key? key,
    required this.onChanged,
    this.label = ' ',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.borderEnabled = true,
    this.fontSize = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: this.keyboardType,
      obscureText: this.obscureText,
      onChanged: this.onChanged,
      decoration: InputDecoration(
        labelText: this.label,
        border: this.borderEnabled ? null : InputBorder.none,
        labelStyle: TextStyle(
          color: Color.fromARGB(171, 0, 0, 0),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
