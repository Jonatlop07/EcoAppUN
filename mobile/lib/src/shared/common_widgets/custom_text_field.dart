import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required Key? key,
    required this.controller,
    required this.decoration,
    required this.maxLength,
    required this.minLines,
    required this.maxLines,
    this.onEditingComplete,
  }) : super(key: key);

  final InputDecoration decoration;
  final int maxLength;
  final int minLines;
  final int maxLines;
  final TextEditingController controller;
  final Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: key,
      controller: controller,
      decoration: decoration,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      keyboardAppearance: Brightness.light,
      onEditingComplete: onEditingComplete,
    );
  }
}
