import 'package:flutter/material.dart';

import '../constants/app.colors.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget(this.errorMessage, {Key? key}) : super(key: key);
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.error),
    );
  }
}
