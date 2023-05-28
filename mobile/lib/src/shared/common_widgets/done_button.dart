import 'package:flutter/material.dart';
import 'package:mobile/src/shared/common_widgets/primary_button.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

import '../constants/app.sizes.dart';

class DoneButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const DoneButton({
    Key? key,
    this.isLoading = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.p48,
      child: isLoading
          ? const CircularProgressIndicator()
          : PrimaryButton(
              text: '¡Hecho!'.hardcoded,
              isLoading: isLoading,
              onPressed: onPressed,
            ),
    );
  }
}
