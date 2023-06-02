import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  const CommonText({
    Key? key,
    required this.text,
    this.fontStyle,
    this.textAlign,
  }) : super(key: key);

  final String text;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    TextStyle? bodyMediumStyle = Theme.of(context).textTheme.bodyMedium;
    return Text(
      text,
      style: bodyMediumStyle!.copyWith(fontStyle: fontStyle ?? bodyMediumStyle.fontStyle),
      textAlign: textAlign ?? TextAlign.left,
    );
  }
}
