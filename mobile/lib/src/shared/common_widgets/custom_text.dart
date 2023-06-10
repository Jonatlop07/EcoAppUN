import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required this.text,
    this.textStyle,
    this.fontStyle,
    this.textAlign,
  }) : super(key: key);

  final String text;
  final TextStyle? textStyle;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = this.textStyle ?? Theme.of(context).textTheme.bodySmall!;
    return Text(
      text,
      style: textStyle.copyWith(fontStyle: fontStyle ?? textStyle.fontStyle),
      textAlign: textAlign ?? TextAlign.left,
    );
  }
}
