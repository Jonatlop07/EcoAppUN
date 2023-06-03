import 'package:flutter/material.dart';

class SimpleTextFormField extends StatelessWidget {
  const SimpleTextFormField({
    required Key? key,
    required this.decoration,
    required this.maxLength,
    required this.minLines,
    required this.maxLines,
    required this.controller,
    required this.validator,
    this.onEditingComplete,
  }) : super(key: key);

  final InputDecoration decoration;
  final int maxLength;
  final int minLines;
  final int maxLines;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      controller: controller,
      decoration: decoration,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      keyboardAppearance: Brightness.light,
      onEditingComplete: onEditingComplete,
    );
  }
}
