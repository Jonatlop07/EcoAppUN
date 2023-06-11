import 'package:flutter/material.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

import '../../../../shared/common_widgets/responsive_center.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../../../shared/constants/breakpoints.dart';
import '../../domain/ecorecovery.dart';

class EcorecoveryWorkshopsFeedBuilder extends StatelessWidget {
  const EcorecoveryWorkshopsFeedBuilder({
    Key? key,
    required this.ecorecoveryWorkshops,
    required this.ecorecoveryWorkshopBuilder,
  }) : super(key: key);

  final List<EcorecoveryWorkshop> ecorecoveryWorkshops;
  final Widget Function(BuildContext, EcorecoveryWorkshop, int) ecorecoveryWorkshopBuilder;

  @override
  Widget build(BuildContext context) {
    String screenTitle = 'Talleres de recuperación de ecosistemas'.hardcoded;
    if (ecorecoveryWorkshops.isEmpty) {
      return ResponsiveCenter(
        child: Column(
          children: [
            gapH20,
            ScreenTitle(text: screenTitle),
            gapH16,
            Text('Ningún taller de recuperación ha sido creado hasta el momento.'.hardcoded),
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
            ScreenTitle(text: screenTitle),
            gapH20,
            ListView.builder(
              padding: insetsV4,
              itemBuilder: (context, index) {
                final item = ecorecoveryWorkshops[index];
                return ecorecoveryWorkshopBuilder(context, item, index);
              },
              itemCount: ecorecoveryWorkshops.length,
            )
          ],
        ),
      );
    }
    return Column(
      children: [
        gapH20,
        ScreenTitle(text: screenTitle),
        gapH16,
        Expanded(
          child: Padding(
            padding: insetsH8,
            child: ListView.builder(
              padding: insetsH4,
              itemBuilder: (context, index) {
                final item = ecorecoveryWorkshops[index];
                return ecorecoveryWorkshopBuilder(context, item, index);
              },
              itemCount: ecorecoveryWorkshops.length,
            ),
          ),
        ),
      ],
    );
  }
}
