import 'package:flutter/material.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

import '../../../../shared/common_widgets/responsive_center.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../../../shared/constants/breakpoints.dart';
import '../../domain/denouncement.dart';

class DenouncementsFeedBuilder extends StatelessWidget {
  const DenouncementsFeedBuilder({
    Key? key,
    required this.denouncements,
    required this.denouncementsBuilder,
  }) : super(key: key);

  final List<Denouncement> denouncements;
  final Widget Function(BuildContext, Denouncement, int) denouncementsBuilder;

  @override
  Widget build(BuildContext context) {
    String screenTitle = 'Denuncias'.hardcoded;
    if (denouncements.isEmpty) {
      return ResponsiveCenter(
        child: Column(
          children: [
            gapH20,
            ScreenTitle(text: screenTitle),
            gapH16,
            Text('Ninguna denuncia ha sido creada hasta el momento.'.hardcoded),
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
            gapH16,
            Expanded(
              child: ListView.builder(
                padding: insetsV4,
                itemBuilder: (context, index) {
                  final item = denouncements[index];
                  return denouncementsBuilder(context, item, index);
                },
                itemCount: denouncements.length,
              ),
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
          child: ListView.builder(
            padding: insetsAll4,
            itemBuilder: (context, index) {
              final item = denouncements[index];
              return denouncementsBuilder(context, item, index);
            },
            itemCount: denouncements.length,
          ),
        ),
      ],
    );
  }
}
