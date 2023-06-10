import 'package:flutter/material.dart';

class TextSpanDetails {
  const TextSpanDetails({required this.text, this.fontStyle, this.fontWeight});

  final String text;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
}

class CommonRichText extends StatelessWidget {
  const CommonRichText({
    Key? key,
    required this.children,
    this.textAlign,
  }) : super(key: key);

  final List<TextSpanDetails> children;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    TextStyle? bodySmallStyle = Theme.of(context).textTheme.bodySmall;
    return RichText(
      text: TextSpan(
        children: children
            .map(
              (child) => TextSpan(
                text: child.text,
                style: bodySmallStyle!.copyWith(
                  fontStyle: child.fontStyle ?? bodySmallStyle.fontStyle,
                  fontWeight: child.fontWeight ?? bodySmallStyle.fontWeight,
                ),
              ),
            )
            .toList(),
      ),
      textAlign: textAlign ?? TextAlign.left,
    );
  }
}
