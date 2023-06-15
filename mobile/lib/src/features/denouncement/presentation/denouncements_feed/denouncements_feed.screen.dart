import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';
import '../../../../shared/common_widgets/list_item_container.dart';
import '../../../../shared/common_widgets/navbar.dart';
import '../../../../shared/common_widgets/popup_menu_item_text.dart';
import '../../../../shared/time/datetime.format.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/common_widgets/async_value.dart';
import '../../data/denouncement_service.dart';
import '../../domain/denouncement.dart';
import '../common/denouncements_feed.builder.dart';

enum DenouncementAction { query, edit, delete }

class DenouncementsFeedScreen extends ConsumerWidget {
  const DenouncementsFeedScreen({
    Key? key,
    required this.onDenouncementSelected,
    required this.onEditDenouncement,
    required this.onDeleteDenouncement,
    required this.onCreateNewDenouncement,
  }) : super(key: key);

  final Function(Denouncement) onDenouncementSelected;
  final Function(Denouncement) onEditDenouncement;
  final Function(String) onDeleteDenouncement;
  final Function() onCreateNewDenouncement;

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
    AsyncValue<List<Denouncement>> denouncementsAsync = ref.watch(
      getAllDenouncementsProvider,
    );
    return AsyncValueWidget<List<Denouncement>>(
      value: denouncementsAsync,
      data: (denouncements) {
        return Scaffold(
          appBar: const NavBar(),
          body: DenouncementsFeedBuilder(
            denouncements: denouncements,
            denouncementsBuilder: (_, denouncement, index) => Padding(
              padding: insetsH12,
              child: ListItemContainer(
                child: SizedBox(
                  width: double.infinity,
                  child: ListTile(
                    title: Text(
                      denouncement.title,
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                DateTimeFormat.toYYYYMMDD(denouncement.createdAt),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                denouncement.description,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                denouncement.denouncerId,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<DenouncementAction>(
                      onSelected: (DenouncementAction selectedAction) async {
                        switch (selectedAction) {
                          case DenouncementAction.query:
                            {
                              onDenouncementSelected.call(denouncement);
                            }
                            break;
                          case DenouncementAction.edit:
                            {
                              onEditDenouncement.call(denouncement);
                            }
                            break;
                          case DenouncementAction.delete:
                            {
                              await _handleOnDelete(denouncement, denouncementService);
                            }
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<DenouncementAction>(
                          value: DenouncementAction.query,
                          child: PopupMenuItemText(
                            text: 'Ver'.hardcoded,
                          ),
                        ),
                        PopupMenuItem<DenouncementAction>(
                          value: DenouncementAction.edit,
                          child: PopupMenuItemText(
                            text: 'Editar'.hardcoded,
                          ),
                        ),
                        PopupMenuItem<DenouncementAction>(
                          value: DenouncementAction.delete,
                          child: PopupMenuItemText(
                            text: 'Eliminar'.hardcoded,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      onDenouncementSelected.call(denouncement);
                    },
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: onCreateNewDenouncement,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
