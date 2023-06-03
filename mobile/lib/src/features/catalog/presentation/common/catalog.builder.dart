import 'package:flutter/material.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

import '../../../../shared/common_widgets/responsive_center.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../../../shared/constants/breakpoints.dart';
import '../../domain/catalog.dart';

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
        child: Column(
          children: [
            gapH20,
            ScreenTitle(text: 'Catálogo de especies'.hardcoded),
            gapH16,
            Text('Ningún artículo del catálogo ha sido creado hasta el momento.'.hardcoded),
          ],
        ),
      );
    }
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= Breakpoint.tablet) {
      return ResponsiveCenter(
        padding: insetsH4,
        child: Column(
          children: [
            ScreenTitle(text: 'Catálogo de especies'.hardcoded),
            gapH16,
            ListView.builder(
              padding: insetsV4,
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
        gapH20,
        ScreenTitle(text: 'Catálogo de especies'.hardcoded),
        gapH16,
        Expanded(
          child: ListView.builder(
            padding: insetsH4,
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
