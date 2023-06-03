import 'package:flutter/material.dart';
import 'package:mobile/src/shared/constants/app.colors.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackButton(
        color: AppColors.lighterGreen,
      ),
      title: Text('AyudaUNCompita'.hardcoded),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(Sizes.p64);
}
