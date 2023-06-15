import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/common_widgets/navbar.dart';
import '../../../../shared/common_widgets/custom_text.dart';
import '../../../../shared/common_widgets/secondary_icon_button.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/common_widgets/common_rich_text.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/common_widgets/subtitle.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../../../shared/time/datetime.format.dart';
import '../../data/denouncement_service.dart';
import '../../domain/denouncement.dart';
import '../common/denouncement_multimedia.widget.dart';

class DenouncementScreen extends ConsumerWidget {
  const DenouncementScreen({
    Key? key,
    required this.denouncement,
    required this.onEditDenouncement,
    required this.onDeleteDenouncement,
  }) : super(key: key);

  final Denouncement denouncement;
  final Function onEditDenouncement;
  final Function onDeleteDenouncement;

  Future<void> _handleOnDelete(
    Denouncement denouncement,
    DenouncementService denouncementService,
  ) async {
    await denouncementService.deleteDenouncement(denouncement.id);
    onDeleteDenouncement.call(denouncement.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DenouncementService denouncementService = ref.watch(denouncementServiceProvider);
    return Scaffold(
        appBar: const NavBar(),
        body: ResponsiveScrollableCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: insetsAll4,
                child: ScreenTitle(text: denouncement.title),
              ),
              gapH4,
              Padding(
                padding: insetsAll4,
                child: CommonRichText(
                  children: <TextSpanDetails>[
                    TextSpanDetails(
                      text: DateTimeFormat.toYYYYMMDD(denouncement.createdAt),
                      fontStyle: FontStyle.italic,
                    ),
                    const TextSpanDetails(text: ' por '),
                    TextSpanDetails(
                      text: denouncement.denouncerId,
                      fontStyle: FontStyle.normal,
                    )
                  ],
                  textAlign: TextAlign.center,
                ),
              ),
              gapH16,
              Padding(
                padding: insetsH12,
                child: DenouncementMultimediaWidget(
                  multimediaElement: DenouncementMultimedia(
                    description: denouncement.description,
                    submittedAt: denouncement.createdAt,
                    uri:
                        'https://www.shutterstock.com/image-vector/cute-flutter-butterflies-tattoo-art-600w-2240487227.jpg',
                  ),
                ),
              ),
              gapH16,
              Padding(
                padding: insetsAll12,
                child: CustomText(
                  text: denouncement.description,
                  textAlign: TextAlign.center,
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
                  children: denouncement.multimediaElements.isEmpty
                      ? [
                          CustomText(
                            text: 'No hay evidencia multimedia para mostrar'.hardcoded,
                            textAlign: TextAlign.center,
                          ),
                        ]
                      : denouncement.multimediaElements
                          .map(
                            (multimediaElement) =>
                                DenouncementMultimediaWidget(multimediaElement: multimediaElement),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SecondaryIconButton(
                          onPressed: () {
                            onEditDenouncement.call(denouncement);
                          },
                          icon: const Icon(Icons.edit),
                          text: 'Editar'.hardcoded,
                        ),
                        gapH16,
                        SecondaryIconButton(
                          onPressed: () async {
                            await _handleOnDelete(denouncement, denouncementService);
                          },
                          icon: const Icon(Icons.delete),
                          text: 'Eliminar'.hardcoded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
