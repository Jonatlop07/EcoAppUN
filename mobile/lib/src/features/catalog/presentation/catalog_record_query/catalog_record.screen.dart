import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/common_widgets/navbar.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/common_widgets/common_text.dart';
import '../../../../shared/common_widgets/common_rich_text.dart';
import '../../../../shared/common_widgets/primary_icon_button.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/common_widgets/subtitle.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../../../shared/time/datetime.format.dart';
import '../../data/catalog.service.dart';
import '../../domain/catalog.dart';
import '../common/catalog_record_image.widget.dart';

class CatalogRecordScreen extends ConsumerWidget {
  const CatalogRecordScreen({
    Key? key,
    required this.catalogRecord,
    required this.onEditCatalogRecord,
    required this.onDeleteCatalogRecord,
  }) : super(key: key);

  final CatalogRecord catalogRecord;
  final Function onEditCatalogRecord;
  final Function onDeleteCatalogRecord;

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
    return Scaffold(
        appBar: const NavBar(),
        body: Column(
          children: [
            ResponsiveScrollableCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: insetsAll4,
                    child: ScreenTitle(text: catalogRecord.commonName),
                  ),
                  gapH4,
                  Padding(
                    padding: insetsAll4,
                    child: CommonText(
                      text: catalogRecord.scientificName,
                      fontStyle: FontStyle.italic,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  gapH4,
                  Padding(
                    padding: insetsAll4,
                    child: CommonRichText(
                      children: <TextSpanDetails>[
                        TextSpanDetails(
                          text: DateTimeFormat.toYYYYMMDD(catalogRecord.createdAt),
                          fontStyle: FontStyle.italic,
                        ),
                        const TextSpanDetails(text: ' por '),
                        TextSpanDetails(
                          text: catalogRecord.authorId,
                          fontStyle: FontStyle.normal,
                        )
                      ],
                      textAlign: TextAlign.center,
                    ),
                  ),
                  gapH16,
                  Padding(
                    padding: insetsH12,
                    child: CatalogRecordImageWidget(
                      image: CatalogRecordImage(
                        id: 'sd',
                        authorId: catalogRecord.authorId,
                        authorName: catalogRecord.authorId,
                        description: catalogRecord.description,
                        submittedAt: catalogRecord.createdAt,
                        url:
                            'https://www.shutterstock.com/image-vector/cute-flutter-butterflies-tattoo-art-600w-2240487227.jpg',
                      ),
                    ),
                  ),
                  gapH16,
                  Padding(
                    padding: insetsAll12,
                    child: CommonText(
                      text: catalogRecord.description,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  gapH16,
                  Padding(
                    padding: insetsAll4,
                    child: Subtitle(
                      text: 'Dónde encontrarle:'.hardcoded,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  gapH4,
                  Padding(
                    padding: insetsAll8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: catalogRecord.locations.isEmpty
                          ? [
                              CommonText(
                                text: 'No hay ubicaciones registradas'.hardcoded,
                                textAlign: TextAlign.center,
                              ),
                            ]
                          : catalogRecord.locations
                              .map(
                                (location) => Padding(
                                  padding: insetsV4,
                                  child: CommonText(text: location),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  gapH16,
                  Padding(
                    padding: insetsAll4,
                    child: Subtitle(
                      text: 'Galería de imagenes:'.hardcoded,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  gapH4,
                  Padding(
                    padding: insetsAll8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: catalogRecord.images.isEmpty
                          ? [
                              CommonText(
                                text: 'No hay más imágenes para mostrar'.hardcoded,
                                textAlign: TextAlign.center,
                              ),
                            ]
                          : catalogRecord.images
                              .map(
                                (image) => CatalogRecordImageWidget(image: image),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: insetsAll16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryIconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_a_photo),
                    text: 'Nueva imagen'.hardcoded,
                  ),
                  gapH16,
                  PrimaryIconButton(
                    onPressed: () {
                      onEditCatalogRecord.call(catalogRecord);
                    },
                    icon: const Icon(Icons.edit),
                    text: 'Editar'.hardcoded,
                  ),
                  gapH16,
                  PrimaryIconButton(
                    onPressed: () async {
                      await handleOnDelete(catalogRecord, catalogService);
                    },
                    icon: const Icon(Icons.delete),
                    text: 'Eliminar'.hardcoded,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
