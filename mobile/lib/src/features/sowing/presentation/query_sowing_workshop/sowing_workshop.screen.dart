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
import '../../data/sowing_service.dart';
import '../../domain/sowing.dart';

class SowingWorkshopScreen extends ConsumerWidget {
  const SowingWorkshopScreen({
    Key? key,
    required this.sowingWorkshop,
    required this.onEditSowingWorkshop,
    required this.onDeleteSowingWorkshop,
  }) : super(key: key);

  final SowingWorkshop sowingWorkshop;
  final Function onEditSowingWorkshop;
  final Function onDeleteSowingWorkshop;

  Future<void> _handleOnDelete(
    SowingWorkshop sowingWorkshop,
    SowingService sowingService,
  ) async {
    await sowingService.deleteSowingWorkshop(sowingWorkshop.id);
    onDeleteSowingWorkshop.call(sowingWorkshop.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SowingService sowingService = ref.watch(sowingServiceProvider);
    return Scaffold(
      appBar: const NavBar(),
      body: ResponsiveScrollableCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: insetsAll4,
              child: ScreenTitle(text: sowingWorkshop.title),
            ),
            gapH4,
            Padding(
              padding: insetsAll4,
              child: CommonRichText(
                children: <TextSpanDetails>[
                  TextSpanDetails(
                    text: DateTimeFormat.toYYYYMMDD(sowingWorkshop.createdAt),
                    fontStyle: FontStyle.italic,
                  ),
                  const TextSpanDetails(text: ' por '),
                  TextSpanDetails(
                    text: sowingWorkshop.authorId,
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
                text: sowingWorkshop.description,
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
                children: sowingWorkshop.instructions.isEmpty
                    ? [
                        CustomText(
                          text:
                              'Hasta el momento, ninguna instrucción se ha especificado'.hardcoded,
                          textAlign: TextAlign.center,
                        ),
                      ]
                    : sowingWorkshop.instructions
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
              padding: insetsAll4,
              child: Subtitle(
                text: 'Semillas a plantar:'.hardcoded,
                textAlign: TextAlign.center,
              ),
            ),
            gapH4,
            /*Padding(
              padding: insetsAll8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: sowingWorkshop.seeds.isEmpty
                    ? [
                        CustomText(
                          text: 'No se ha indicado semillas para plantar'.hardcoded,
                          textAlign: TextAlign.center,
                        ),
                      ]
                    : sowingWorkshop.seeds
                        .map(
                          (seed) => SowingWorkshopSeedWidget(seed: seed),
                        )
                        .toList(),
              ),
            ),*/
            gapH16,
            Padding(
              padding: insetsAll16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SecondaryIconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_a_photo),
                    text: 'Aportar con semillas'.hardcoded,
                  ),
                  gapH16,
                  SecondaryIconButton(
                    onPressed: () {
                      onEditSowingWorkshop.call(sowingWorkshop);
                    },
                    icon: const Icon(Icons.edit),
                    text: 'Editar'.hardcoded,
                  ),
                  gapH16,
                  SecondaryIconButton(
                    onPressed: () async {
                      await _handleOnDelete(sowingWorkshop, sowingService);
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
