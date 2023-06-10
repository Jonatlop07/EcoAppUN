import 'package:flutter/material.dart';
import 'package:mobile/src/shared/constants/app.colors.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';

class ListItemContainer extends StatelessWidget {
  const ListItemContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: insetsV12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.white,
        boxShadow: const [BoxShadow(blurRadius: Sizes.p4, color: AppColors.lighterGreen)],
      ),
      child: child,
    );
  }
}
