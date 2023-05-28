import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/shared/common_widgets/primary_button.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';
import 'package:mobile/src/shared/routing/route_paths.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '404 - Página no encontrada',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              gapH32,
              PrimaryButton(
                onPressed: () => context.go(RoutePaths.catalog),
                text: 'Autenticarse'.hardcoded,
              )
            ],
          ),
        ),
      ),
    );
  }
}
