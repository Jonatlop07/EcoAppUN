import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/app.dart';
import 'package:mobile/src/shared/constants/app.colors.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await runZonedGuarded(() async {
    runApp(const ProviderScope(child: MyApp()));
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.error,
          title: Text('Ocurrió un error'.hardcoded),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }, (Object error, StackTrace stack) {
    debugPrint(error.toString());
    debugPrintStack(stackTrace: stack);
  });
}
