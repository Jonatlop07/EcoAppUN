import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/features/catalog/presentation/edit_catalog_record/edit_catalog_record.screen.dart';
import 'package:mobile/src/features/sowing/domain/sowing.dart';
import 'package:mobile/src/features/sowing/presentation/create_sowing_workshop/create_sowing_workshop.screen.dart';
import '../../features/catalog/domain/catalog.dart';
import '../../features/catalog/presentation/catalog_query/catalog.screen.dart';
import '../../features/catalog/presentation/catalog_record_query/catalog_record.screen.dart';
import '../../features/catalog/presentation/create_catalog_record/create_catalog_record.screen.dart';
import '../../features/denouncement/domain/denouncement.dart';
import '../../features/denouncement/presentation/denouncement_query/denouncement.screen.dart';
import '../../features/denouncement/presentation/create_denouncement/create_denouncement.screen.dart';
import '../../features/denouncement/presentation/denouncements_feed/denouncements_feed.screen.dart';
import '../../features/denouncement/presentation/edit_catalog_record/edit_denouncement.screen.dart';
import '../../features/ecorecovery/domain/ecorecovery.dart';
import '../../features/ecorecovery/presentation/create_ecorecovery_workshop/create_ecorecovery_workshop.screen.dart';
import '../../features/ecorecovery/presentation/ecorecovery_workshops_feed/ecorecovery_workshops_feed.screen.dart';
import '../../features/ecorecovery/presentation/edit_ecorecovery_workshop/edit_sowing_workshop.screen.dart';
import '../../features/ecorecovery/presentation/query_ecorecovery_workshop/ecorecovery_workshop.screen.dart';
import '../../features/ecotour/domain/ecotour.dart';
import '../../features/ecotour/presentation/create_ecotour/create_ecotour.screen.dart';
import '../../features/ecotour/presentation/ecotours_feed/ecotours_feed.screen.dart';
import '../../features/ecotour/presentation/edit_ecotour/edit_sowing_workshop.screen.dart';
import '../../features/ecotour/presentation/query_ecotour/ecotour.screen.dart';
import '../../features/sowing/presentation/edit_sowing_workshop/edit_sowing_workshop.screen.dart';
import '../../features/sowing/presentation/query_sowing_workshop/sowing_workshop.screen.dart';
import '../../features/sowing/presentation/sowing_workshops_feed/sowing_workshops_feed.screen.dart';
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
        name: Routes.denouncements,
        pageBuilder: (context, state) => TransitionScreen.createFade(
          context,
          state,
          DenouncementsFeedScreen(
            onDenouncementSelected: (Denouncement denouncement) {
              context.pushNamed(
                Routes.queryDenouncement,
                pathParameters: {"denouncementId": denouncement.id},
                extra: denouncement.toJson(),
              );
            },
            onEditDenouncement: (Denouncement denouncement) {
              context.pushNamed(
                Routes.editDenouncement,
                pathParameters: {"denouncementId": denouncement.id},
                extra: denouncement.toJson(),
              );
            },
            onDeleteDenouncement: (String denouncementId) {
              context.pushNamed(Routes.denouncements);
            },
            onCreateNewDenouncement: () {
              context.pushNamed(Routes.createDenouncement);
            },
          ),
        ),
        routes: [
          GoRoute(
            path: 'create',
            name: Routes.createDenouncement,
            pageBuilder: (context, state) => TransitionScreen.createFade(
              context,
              state,
              const CreateDenouncementScreen(),
            ),
          ),
          GoRoute(
            path: 'edit/:denouncementId',
            name: Routes.editDenouncement,
            pageBuilder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              Denouncement denouncement = Denouncement.fromJson(data);
              return TransitionScreen.createFade(
                context,
                state,
                EditDenouncementScreen(
                  denouncement: denouncement,
                ),
              );
            },
          ),
          GoRoute(
            path: ':denouncementId',
            name: Routes.queryDenouncement,
            pageBuilder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              Denouncement denouncement = Denouncement.fromJson(data);
              return TransitionScreen.createFade(
                context,
                state,
                DenouncementScreen(
                  denouncement: denouncement,
                  onEditDenouncement: (Denouncement denouncement) {
                    context.pushNamed(
                      Routes.editDenouncement,
                      pathParameters: {"denouncementId": denouncement.id},
                      extra: denouncement.toJson(),
                    );
                  },
                  onDeleteDenouncement: (String denouncementId) {
                    context.pushNamed(Routes.denouncements);
                  },
                ),
              );
            },
          ),
        ],
      ),
      /*GoRoute(
        path: '/',
        name: Routes.ecotours,
        pageBuilder: (context, state) => TransitionScreen.createFade(
          context,
          state,
          EcotoursFeedScreen(
            onEcotourSelected: (Ecotour ecotour) {
              context.pushNamed(
                Routes.queryEcotour,
                pathParameters: {"ecotourId": ecotour.id},
                extra: ecotour.toJson(),
              );
            },
            onEditEcotour: (Ecotour ecotour) {
              context.pushNamed(
                Routes.editEcotour,
                pathParameters: {"ecotourId": ecotour.id},
                extra: ecotour.toJson(),
              );
            },
            onDeleteEcotour: (String ecotourId) {
              context.pushNamed(Routes.ecotours);
            },
            onCreateNewEcotour: () {
              context.pushNamed(Routes.createEcotour);
            },
          ),
        ),
        routes: [
          GoRoute(
            path: 'create',
            name: Routes.createEcotour,
            pageBuilder: (context, state) => TransitionScreen.createFade(
              context,
              state,
              const CreateEcotourScreen(),
            ),
          ),
          GoRoute(
            path: 'edit/:ecotourId',
            name: Routes.editEcotour,
            pageBuilder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              Ecotour ecotour = Ecotour.fromJson(data);
              return TransitionScreen.createFade(
                context,
                state,
                EditEcotourScreen(
                  ecotour: ecotour,
                ),
              );
            },
          ),
          GoRoute(
            path: ':ecotourId',
            name: Routes.queryEcotour,
            pageBuilder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              Ecotour ecotour = Ecotour.fromJson(data);
              return TransitionScreen.createFade(
                context,
                state,
                EcotourScreen(
                  ecotour: ecotour,
                  onEditEcotour: (Ecotour ecotour) {
                    context.pushNamed(
                      Routes.editEcotour,
                      pathParameters: {"ecotourId": ecotour.id},
                      extra: ecotour.toJson(),
                    );
                  },
                  onDeleteEcotour: (String ecotourId) {
                    context.pushNamed(Routes.ecotours);
                  },
                ),
              );
            },
          ),
        ],
      ),*/
      /*GoRoute(
        path: '/',
        name: Routes.ecorecoveryWorkshops,
        pageBuilder: (context, state) => TransitionScreen.createFade(
          context,
          state,
          EcorecoveryWorkshopsFeedScreen(
            onEcorecoveryWorkshopSelected: (EcorecoveryWorkshop ecorecoveryWorkshop) {
              context.pushNamed(
                Routes.queryEcorecoveryWorkshop,
                pathParameters: {"ecorecoveryWorkshopId": ecorecoveryWorkshop.id},
                extra: ecorecoveryWorkshop.toJson(),
              );
            },
            onEditEcorecoveryWorkshop: (EcorecoveryWorkshop ecorecoveryWorkshop) {
              context.pushNamed(
                Routes.editEcorecoveryWorkshop,
                pathParameters: {"ecorecoveryWorkshopId": ecorecoveryWorkshop.id},
                extra: ecorecoveryWorkshop.toJson(),
              );
            },
            onDeleteEcorecoveryWorkshop: (String ecorecoveryWorkshopId) {
              context.pushNamed(Routes.ecorecoveryWorkshops);
            },
            onCreateNewEcorecoveryWorkshop: () {
              context.pushNamed(Routes.createEcorecoveryWorkshop);
            },
          ),
        ),
        routes: [
          GoRoute(
            path: 'create',
            name: Routes.createEcorecoveryWorkshop,
            pageBuilder: (context, state) => TransitionScreen.createFade(
              context,
              state,
              const CreateEcorecoveryWorkshopScreen(),
            ),
          ),
          GoRoute(
            path: 'edit/:ecorecoveryWorkshopId',
            name: Routes.editEcorecoveryWorkshop,
            pageBuilder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              EcorecoveryWorkshop ecorecoveryWorkshop = EcorecoveryWorkshop.fromJson(data);
              return TransitionScreen.createFade(
                context,
                state,
                EditEcorecoveryWorkshopScreen(
                  ecorecoveryWorkshop: ecorecoveryWorkshop,
                ),
              );
            },
          ),
          GoRoute(
            path: ':ecorecoveryWorkshopId',
            name: Routes.queryEcorecoveryWorkshop,
            pageBuilder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              EcorecoveryWorkshop ecorecoveryWorkshop = EcorecoveryWorkshop.fromJson(data);
              return TransitionScreen.createFade(
                context,
                state,
                EcorecoveryWorkshopScreen(
                  ecorecoveryWorkshop: ecorecoveryWorkshop,
                  onEditEcorecoveryWorkshop: (EcorecoveryWorkshop ecorecoveryWorkshop) {
                    context.pushNamed(
                      Routes.editEcorecoveryWorkshop,
                      pathParameters: {"ecorecoveryWorkshopId": ecorecoveryWorkshop.id},
                      extra: ecorecoveryWorkshop.toJson(),
                    );
                  },
                  onDeleteEcorecoveryWorkshop: (String ecorecoveryWorkshopId) {
                    context.pushNamed(Routes.ecorecoveryWorkshops);
                  },
                ),
              );
            },
          ),
        ],
      ),*/
      /*GoRoute(
        path: '/',
        name: Routes.sowingWorkshops,
        pageBuilder: (context, state) => TransitionScreen.createFade(
          context,
          state,
          SowingWorkshopsFeedScreen(
            onSowingWorkshopSelected: (SowingWorkshop sowingWorkshop) {
              context.pushNamed(
                Routes.querySowingWorkshop,
                pathParameters: {"sowingWorkshopId": sowingWorkshop.id},
                extra: sowingWorkshop.toJson(),
              );
            },
            onEditSowingWorkshop: (SowingWorkshop sowingWorkshop) {
              context.pushNamed(
                Routes.editSowingWorkshop,
                pathParameters: {"sowingWorkshopId": sowingWorkshop.id},
                extra: sowingWorkshop.toJson(),
              );
            },
            onDeleteSowingWorkshop: (String sowingWorkshopId) {
              context.pushNamed(Routes.sowingWorkshops);
            },
            onCreateNewSowingWorkshop: () {
              context.pushNamed(Routes.createSowingWorkshop);
            },
          ),
        ),
        routes: [
          GoRoute(
            path: 'create',
            name: Routes.createSowingWorkshop,
            pageBuilder: (context, state) => TransitionScreen.createFade(
              context,
              state,
              const CreateSowingWorkshopScreen(),
            ),
          ),
          GoRoute(
            path: 'edit/:sowingWorkshopId',
            name: Routes.editSowingWorkshop,
            pageBuilder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              SowingWorkshop sowingWorkshop = SowingWorkshop.fromJson(data);
              return TransitionScreen.createFade(
                context,
                state,
                EditSowingWorkshopScreen(
                  sowingWorkshop: sowingWorkshop,
                ),
              );
            },
          ),
          GoRoute(
            path: ':sowingWorkshopId',
            name: Routes.querySowingWorkshop,
            pageBuilder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              SowingWorkshop sowingWorkshop = SowingWorkshop.fromJson(data);
              return TransitionScreen.createFade(
                context,
                state,
                SowingWorkshopScreen(
                  sowingWorkshop: sowingWorkshop,
                  onEditSowingWorkshop: (SowingWorkshop sowingWorkshop) {
                    context.pushNamed(
                      Routes.editSowingWorkshop,
                      pathParameters: {"sowingWorkshopId": sowingWorkshop.id},
                      extra: sowingWorkshop.toJson(),
                    );
                  },
                  onDeleteSowingWorkshop: (String sowingWorkshopId) {
                    context.pushNamed(Routes.sowingWorkshops);
                  },
                ),
              );
            },
          ),
        ],
      ),*/
      /*GoRoute(
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
      ),*/
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
