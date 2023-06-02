import 'package:flutter/material.dart';
import '../constants/app.sizes.dart';

class PrimaryIconButton extends StatelessWidget {
  const PrimaryIconButton({
    Key? key,
    required this.text,
    required this.icon,
    this.isLoading = false,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final Icon icon;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.p32,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: isLoading
            ? const CircularProgressIndicator()
            : Text(
                text,
              ),
      ),
    );
  }
}
