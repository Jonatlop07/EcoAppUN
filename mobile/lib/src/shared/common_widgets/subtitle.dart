import 'package:flutter/material.dart';

class Subtitle extends StatelessWidget {
  const Subtitle({
    Key? key,
    required this.text,
    this.textAlign,
  }) : super(key: key);

  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium,
      textAlign: textAlign ?? TextAlign.left,
    );
  }
}
