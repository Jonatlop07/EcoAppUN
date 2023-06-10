import 'package:flutter/material.dart';

class PopupMenuItemText extends StatelessWidget {
  const PopupMenuItemText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    TextStyle? bodyMediumStyle = Theme.of(context).textTheme.bodyMedium;
    return Text(
      text,
      style: bodyMediumStyle!,
    );
  }
}
