import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/routing/not_found.screen.dart';
import 'package:mobile/src/core/routing/transition.screen.dart';
import 'package:mobile/src/features/catalog/presentation/create_catalog_record/create_catalog_record.screen.dart';
import 'package:mobile/src/shared/routing/routes.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: Routes.catalog,
        pageBuilder: (context, state) => TransitionScreen.createFade(
          context,
          state,
          const CreateCatalogRecordScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
