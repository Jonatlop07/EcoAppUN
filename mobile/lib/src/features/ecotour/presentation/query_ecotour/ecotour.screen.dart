import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/common_widgets/navbar.dart';
import '../../../../shared/common_widgets/secondary_icon_button.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/common_widgets/custom_text.dart';
import '../../../../shared/common_widgets/common_rich_text.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../../../shared/time/datetime.format.dart';
import '../../data/ecotour_service.dart';
import '../../domain/ecotour.dart';

class EcotourScreen extends ConsumerWidget {
  const EcotourScreen({
    Key? key,
    required this.ecotour,
    required this.onEditEcotour,
    required this.onDeleteEcotour,
  }) : super(key: key);

  final Ecotour ecotour;
  final Function onEditEcotour;
  final Function onDeleteEcotour;

  Future<void> _handleOnDelete(
    Ecotour ecotour,
    EcotourService ecotourService,
  ) async {
    await ecotourService.deleteEcotour(ecotour.id);
    onDeleteEcotour.call(ecotour.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EcotourService ecotourService = ref.watch(ecotourServiceProvider);
    return Scaffold(
      appBar: const NavBar(),
      body: ResponsiveScrollableCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: insetsAll4,
              child: ScreenTitle(text: ecotour.title),
            ),
            gapH4,
            Padding(
              padding: insetsAll4,
              child: CommonRichText(
                children: <TextSpanDetails>[
                  TextSpanDetails(
                    text: DateTimeFormat.toYYYYMMDD(ecotour.createdAt),
                    fontStyle: FontStyle.italic,
                  ),
                  const TextSpanDetails(text: ' por '),
                  TextSpanDetails(
                    text: ecotour.authorId,
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
                text: ecotour.description,
                textAlign: TextAlign.center,
              ),
            ),
            gapH16,
            Padding(
              padding: insetsAll12,
              child: CustomText(
                text: 'Fecha del evento: ${ecotour.date.toString()}',
                textAlign: TextAlign.center,
              ),
            ),
            gapH8,
            Padding(
              padding: insetsAll12,
              child: CustomText(
                text: 'Hora de inicio: ${ecotour.startTime.toString()}',
                textAlign: TextAlign.center,
              ),
            ),
            gapH8,
            Padding(
              padding: insetsAll12,
              child: CustomText(
                text: 'Hora de finalización: ${ecotour.endTime.toString()}',
                textAlign: TextAlign.center,
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
                      onEditEcotour.call(ecotour);
                    },
                    icon: const Icon(Icons.edit),
                    text: 'Editar'.hardcoded,
                  ),
                  gapH16,
                  SecondaryIconButton(
                    onPressed: () async {
                      await _handleOnDelete(ecotour, ecotourService);
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
