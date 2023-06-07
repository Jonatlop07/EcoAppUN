import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/features/catalog/presentation/edit_catalog_record/edit_catalog_record.screen.dart';
import 'package:mobile/src/features/sowing/presentation/create_sowing_workshop/create_sowing_workshop.screen.dart';
import '../../features/catalog/domain/catalog.dart';
import '../../features/catalog/presentation/catalog_query/catalog.screen.dart';
import '../../features/catalog/presentation/catalog_record_query/catalog_record.screen.dart';
import '../../features/catalog/presentation/create_catalog_record/create_catalog_record.screen.dart';
import '../../shared/routing/routes.dart';
import 'not_found.screen.dart';
import 'transition.screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: Routes.createSowingWorkshop,
        pageBuilder: (context, state) => TransitionScreen.createFade(
          context,
          state,
          const CreateSowingWorkshopScreen(),
        ),
      )
      /*  GoRoute(
        path: '/',
        name: Routes.catalog,
        pageBuilder: (context, state) => TransitionScreen.createFade(
          context,
          state,
          CatalogScreen(
            onCatalogRecordSelected: (CatalogRecord catalogRecord) {
              context.pushNamed(
                Routes.queryCatalogRecord,
                pathParameters: {"catalogRecordId": catalogRecord.id},
                extra: catalogRecord.toJson(),
              );
            },
            onEditCatalogRecord: (CatalogRecord catalogRecord) {
              context.pushNamed(
                Routes.editCatalogRecord,
                pathParameters: {"catalogRecordId": catalogRecord.id},
                extra: catalogRecord.toJson(),
              );
            },
            onDeleteCatalogRecord: (String catalogRecordId) {
              context.pushNamed(Routes.catalog);
            },
            onCreateNewCatalogRecord: () {
              context.pushNamed(Routes.createCatalogRecord);
            },
          ),
        ),
        routes: [
          GoRoute(
            path: 'create',
            name: Routes.createCatalogRecord,
            pageBuilder: (context, state) => TransitionScreen.createFade(
              context,
              state,
              const CreateCatalogRecordScreen(),
            ),
          ),
          GoRoute(
            path: 'edit/:catalogRecordId',
            name: Routes.editCatalogRecord,
            pageBuilder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              CatalogRecord catalogRecord = CatalogRecord.fromJson(data);
              return TransitionScreen.createFade(
                context,
                state,
                EditCatalogRecordScreen(
                  catalogRecord: catalogRecord,
                ),
              );
            },
          ),
          GoRoute(
            path: ':catalogRecordId',
            name: Routes.queryCatalogRecord,
            pageBuilder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              CatalogRecord catalogRecord = CatalogRecord.fromJson(data);
              return TransitionScreen.createFade(
                context,
                state,
                CatalogRecordScreen(
                  catalogRecord: catalogRecord,
                  onEditCatalogRecord: (CatalogRecord catalogRecord) {
                    context.pushNamed(
                      Routes.editCatalogRecord,
                      pathParameters: {"catalogRecordId": catalogRecord.id},
                      extra: catalogRecord.toJson(),
                    );
                  },
                  onDeleteCatalogRecord: (String catalogRecordId) {
                    context.pushNamed(Routes.catalog);
                  },
                ),
              );
            },
          ),
        ],
      ),
    */
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
