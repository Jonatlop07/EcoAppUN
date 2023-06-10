import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({
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
      style: Theme.of(context).textTheme.titleLarge,
      textAlign: textAlign ?? TextAlign.center,
    );
  }
}
