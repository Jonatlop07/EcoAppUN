
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/common_widgets/navbar.dart';
import '../../../../shared/common_widgets/secondary_icon_button.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/common_widgets/custom_text.dart';
import '../../../../shared/common_widgets/common_rich_text.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/common_widgets/subtitle.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../../../shared/time/datetime.format.dart';
import '../../data/ecorecovery_service.dart';
import '../../domain/ecorecovery.dart';

class EcorecoveryWorkshopScreen extends ConsumerWidget {
  const EcorecoveryWorkshopScreen({
    Key? key,
    required this.ecorecoveryWorkshop,
    required this.onEditEcorecoveryWorkshop,
    required this.onDeleteEcorecoveryWorkshop,
  }) : super(key: key);

  final EcorecoveryWorkshop ecorecoveryWorkshop;
  final Function onEditEcorecoveryWorkshop;
  final Function onDeleteEcorecoveryWorkshop;

  Future<void> _handleOnDelete(
    EcorecoveryWorkshop ecorecoveryWorkshop,
    EcorecoveryService ecorecoveryService,
  ) async {
    await ecorecoveryService.deleteWorkshop(ecorecoveryWorkshop.id);
    onDeleteEcorecoveryWorkshop.call(ecorecoveryWorkshop.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EcorecoveryService ecorecoveryService = ref.watch(ecorecoveryServiceProvider);
    return Scaffold(
      appBar: const NavBar(),
      body: ResponsiveScrollableCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: insetsAll4,
              child: ScreenTitle(text: ecorecoveryWorkshop.title),
            ),
            gapH4,
            Padding(
              padding: insetsAll4,
              child: CommonRichText(
                children: <TextSpanDetails>[
                  TextSpanDetails(
                    text: DateTimeFormat.toYYYYMMDD(ecorecoveryWorkshop.createdAt),
                    fontStyle: FontStyle.italic,
                  ),
                  const TextSpanDetails(text: ' por '),
                  TextSpanDetails(
                    text: ecorecoveryWorkshop.authorId,
                    fontStyle: FontStyle.normal,
                  )
                ],
                textAlign: TextAlign.center,
              ),
            ),
            gapH16,
            Padding(
              padding: insetsAll12,
              child: CustomText(
                text: ecorecoveryWorkshop.description,
                textAlign: TextAlign.center,
              ),
            ),
            gapH8,
            Padding(
              padding: insetsAll4,
              child: Subtitle(
                text: 'Instrucciones:'.hardcoded,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: insetsAll8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ecorecoveryWorkshop.instructions.isEmpty
                    ? [
                        CustomText(
                          text:
                              'Hasta el momento, ninguna instrucción se ha especificado'.hardcoded,
                          textAlign: TextAlign.center,
                        ),
                      ]
                    : ecorecoveryWorkshop.instructions
                        .map(
                          (instruction) => Padding(
                            padding: insetsV4,
                            child: CustomText(text: instruction),
                          ),
                        )
                        .toList(),
              ),
            ),
            gapH16,
            Padding(
              padding: insetsAll16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SecondaryIconButton(
                    onPressed: () {
                      onEditEcorecoveryWorkshop.call(ecorecoveryWorkshop);
                    },
                    icon: const Icon(Icons.edit),
                    text: 'Editar'.hardcoded,
                  ),
                  gapH16,
                  SecondaryIconButton(
                    onPressed: () async {
                      await _handleOnDelete(ecorecoveryWorkshop, ecorecoveryService);
                    },
                    icon: const Icon(Icons.delete),
                    text: 'Eliminar'.hardcoded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
