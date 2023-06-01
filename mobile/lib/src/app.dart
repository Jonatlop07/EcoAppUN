import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/core/theme/light.theme.dart';
import 'package:mobile/src/shared/constants/app.colors.dart';
import 'core/routing/app.router.dart';
import 'shared/constants/palette.dart';
import 'shared/localization/string.hardcoded.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      builder: (context, child) => SafeArea(
        top: true,
        maintainBottomViewPadding: true,
        child: child!,
      ),
      routerDelegate: goRouter.routerDelegate,
      routeInformationParser: goRouter.routeInformationParser,
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      onGenerateTitle: (BuildContext context) => 'AyudaUNCompita'.hardcoded,
      theme: lightTheme,
    );
  }
}
