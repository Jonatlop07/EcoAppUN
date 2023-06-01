import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/time/datetime.format.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/common_widgets/async_value.dart';
import '../../data/catalog.service.dart';
import '../../domain/catalog.dart';
import '../catalog.builder.dart';

enum CatalogRecordAction { query, edit, delete }

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({
    Key? key,
    required this.onCatalogRecordSelected,
    required this.onEditCatalogRecord,
    required this.onDeleteCatalogRecord,
    required this.onCreateNewCatalogRecord,
  }) : super(key: key);

  final Function(String) onCatalogRecordSelected;
  final Function(String) onEditCatalogRecord;
  final Function(String) onDeleteCatalogRecord;
  final Function() onCreateNewCatalogRecord;

  Future<void> handleOnDelete(
    CatalogRecord catalogRecord,
    CatalogService catalogService,
  ) async {
    await catalogService.deleteCatalogRecord(catalogRecord.id);
    onDeleteCatalogRecord.call(catalogRecord.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CatalogService catalogService = ref.watch(catalogServiceProvider);
    AsyncValue<List<CatalogRecord>> catalogRecordsAsync = ref.watch(
      getAllCatalogRecordsProvider,
    );
    return AsyncValueWidget<List<CatalogRecord>>(
      value: catalogRecordsAsync,
      data: (catalogRecords) {
        return Scaffold(
          appBar: null,
          body: CatalogBuilder(
            catalogRecords: catalogRecords,
            catalogRecordBuilder: (_, catalogRecord, index) => ListTile(
              leading: CachedNetworkImage(
                imageUrl:
                    'https://www.shutterstock.com/image-vector/cute-flutter-butterflies-tattoo-art-600w-2240487227.jpg',
                placeholder: (context, url) => const CircularProgressIndicator(),
                imageBuilder: (context, imageProvider) => Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  ),
                ),
              ),
              title: Text(
                catalogRecord.commonName,
                textAlign: TextAlign.center,
              ),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          DateTimeFormat.toYYYYMMDD(catalogRecord.createdAt),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          catalogRecord.description,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          catalogRecord.authorId,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: PopupMenuButton<CatalogRecordAction>(
                onSelected: (CatalogRecordAction selectedAction) async {
                  switch (selectedAction) {
                    case CatalogRecordAction.query:
                      {
                        onCatalogRecordSelected.call(catalogRecord.id);
                      }
                      break;
                    case CatalogRecordAction.edit:
                      {
                        onEditCatalogRecord.call(catalogRecord.id);
                      }
                      break;
                    case CatalogRecordAction.delete:
                      {
                        await handleOnDelete(catalogRecord, catalogService);
                      }
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<CatalogRecordAction>(
                    value: CatalogRecordAction.query,
                    child: Text('Ver'.hardcoded),
                  ),
                  PopupMenuItem<CatalogRecordAction>(
                    value: CatalogRecordAction.edit,
                    child: Text('Editar'.hardcoded),
                  ),
                  PopupMenuItem<CatalogRecordAction>(
                    value: CatalogRecordAction.delete,
                    child: Text('Eliminar'.hardcoded),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: onCreateNewCatalogRecord,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
