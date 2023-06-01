import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/catalog/presentation/catalog_query/catalog.screen.dart';
import '../../shared/routing/routes.dart';
import 'not_found.screen.dart';
import 'transition.screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      /*GoRoute(
        path: '/',
        name: Routes.catalog,
        pageBuilder: (context, state) => TransitionScreen.createFade(
          context,
          state,
          const CreateCatalogRecordScreen(
            onCatalogRecordCreated: (String catalogRecordId) {}
          ),
        ),
      ),*/
      GoRoute(
        path: '/',
        name: Routes.catalog,
        pageBuilder: (context, state) => TransitionScreen.createFade(
          context,
          state,
          CatalogScreen(
            onCatalogRecordSelected: (String catalogRecordId) {},
            onEditCatalogRecord: (String catalogRecordId) {},
            onDeleteCatalogRecord: (String catalogRecordId) {},
            onCreateNewCatalogRecord: () {},
          ),
        ),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
