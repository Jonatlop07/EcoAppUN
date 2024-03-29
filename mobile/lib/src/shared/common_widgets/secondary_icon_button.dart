import 'package:flutter/material.dart';

import '../constants/app.sizes.dart';

class SecondaryIconButton extends StatelessWidget {
  const SecondaryIconButton({
    Key? key,
    required this.text,
    required this.icon,
    this.isLoading = false,
    this.onPressed,
    this.height,
  }) : super(key: key);

  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Icon icon;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Sizes.p48,
      child: isLoading
          ? const CircularProgressIndicator()
          : OutlinedButton.icon(
              icon: icon,
              onPressed: onPressed,
              label: Text(
                text,
              ),
            ),
    );
  }
}
