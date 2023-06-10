import 'package:flutter/material.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

import '../../../shared/common_widgets/responsive_center.dart';
import '../../../shared/common_widgets/screen_title.dart';
import '../../../shared/constants/app.sizes.dart';
import '../../../shared/constants/breakpoints.dart';
import '../domain/sowing.dart';

class SowingWorkshopsFeedBuilder extends StatelessWidget {
  const SowingWorkshopsFeedBuilder({
    Key? key,
    required this.sowingWorkshops,
    required this.sowingWorkshopBuilder,
  }) : super(key: key);

  final List<SowingWorkshop> sowingWorkshops;
  final Widget Function(BuildContext, SowingWorkshop, int) sowingWorkshopBuilder;

  @override
  Widget build(BuildContext context) {
    String screenTitle = 'Talleres de siembra'.hardcoded;
    if (sowingWorkshops.isEmpty) {
      return ResponsiveCenter(
        child: Column(
          children: [
            gapH20,
            ScreenTitle(text: screenTitle),
            gapH16,
            Text('Ningún taller de siembra ha sido creado hasta el momento.'.hardcoded),
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
                final item = sowingWorkshops[index];
                return sowingWorkshopBuilder(context, item, index);
              },
              itemCount: sowingWorkshops.length,
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
                final item = sowingWorkshops[index];
                return sowingWorkshopBuilder(context, item, index);
              },
              itemCount: sowingWorkshops.length,
            ),
          ),
        ),
      ],
    );
  }
}
