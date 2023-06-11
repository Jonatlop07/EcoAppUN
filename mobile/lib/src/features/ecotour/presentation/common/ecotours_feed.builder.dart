import 'package:flutter/material.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

import '../../../../shared/common_widgets/responsive_center.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../../../shared/constants/breakpoints.dart';
import '../../domain/ecotour.dart';

class EcotoursFeedBuilder extends StatelessWidget {
  const EcotoursFeedBuilder({
    Key? key,
    required this.ecotours,
    required this.ecotourBuilder,
  }) : super(key: key);

  final List<Ecotour> ecotours;
  final Widget Function(BuildContext, Ecotour, int) ecotourBuilder;

  @override
  Widget build(BuildContext context) {
    String screenTitle = 'Toures ecológicos'.hardcoded;
    if (ecotours.isEmpty) {
      return ResponsiveCenter(
        child: Column(
          children: [
            gapH20,
            ScreenTitle(text: screenTitle),
            gapH16,
            Text('Ningún tour ecológico ha sido registrado hasta el momento.'.hardcoded),
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
                final item = ecotours[index];
                return ecotourBuilder(context, item, index);
              },
              itemCount: ecotours.length,
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
                final item = ecotours[index];
                return ecotourBuilder(context, item, index);
              },
              itemCount: ecotours.length,
            ),
          ),
        ),
      ],
    );
  }
}
