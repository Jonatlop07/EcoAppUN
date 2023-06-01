import 'package:flutter/material.dart';
import 'package:mobile/src/features/catalog/domain/catalog.dart';
import 'package:mobile/src/shared/common_widgets/responsive_center.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';
import 'package:mobile/src/shared/constants/breakpoints.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

class CatalogBuilder extends StatelessWidget {
  const CatalogBuilder({
    Key? key,
    required this.catalogRecords,
    required this.catalogRecordBuilder,
  }) : super(key: key);

  final List<CatalogRecord> catalogRecords;
  final Widget Function(BuildContext, CatalogRecord, int) catalogRecordBuilder;

  @override
  Widget build(BuildContext context) {
    if (catalogRecords.isEmpty) {
      return ResponsiveCenter(
        child: Text('Ningún artículo del catálogo ha sido creado hasta el momento.'.hardcoded),
      );
    }
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= Breakpoint.tablet) {
      return ResponsiveCenter(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: Row(
          children: [
            ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: Sizes.p4),
              itemBuilder: (context, index) {
                final item = catalogRecords[index];
                return catalogRecordBuilder(context, item, index);
              },
              itemCount: catalogRecords.length,
            )
          ],
        ),
      );
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(Sizes.p4),
            itemBuilder: (context, index) {
              final item = catalogRecords[index];
              return catalogRecordBuilder(context, item, index);
            },
            itemCount: catalogRecords.length,
          ),
        ),
      ],
    );
  }
}
