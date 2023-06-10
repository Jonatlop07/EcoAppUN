import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/common_widgets/popup_menu_item_text.dart';
import '../../../../shared/common_widgets/list_item_container.dart';
import '../../../../shared/common_widgets/navbar.dart';
import '../../../../shared/time/datetime.format.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/common_widgets/async_value.dart';
import '../../common/sowing_workshops_feed.builder.dart';
import '../../data/sowing_service.dart';
import '../../domain/sowing.dart';

enum SowingWorkshopAction { query, edit, delete }

class SowingWorkshopsFeedScreen extends ConsumerWidget {
  const SowingWorkshopsFeedScreen({
    Key? key,
    required this.onSowingWorkshopSelected,
    required this.onEditSowingWorkshop,
    required this.onDeleteSowingWorkshop,
    required this.onCreateNewSowingWorkshop,
  }) : super(key: key);

  final Function(SowingWorkshop) onSowingWorkshopSelected;
  final Function(SowingWorkshop) onEditSowingWorkshop;
  final Function(String) onDeleteSowingWorkshop;
  final Function() onCreateNewSowingWorkshop;

  Future<void> _handleOnDelete(
    SowingWorkshop sowingWorkshop,
    SowingService catalogService,
  ) async {
    await catalogService.deleteSowingWorkshop(sowingWorkshop.id);
    onDeleteSowingWorkshop.call(sowingWorkshop.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SowingService catalogService = ref.watch(sowingServiceProvider);
    AsyncValue<List<SowingWorkshop>> sowingWorkshopsAsync = ref.watch(
      getAllSowingWorkshopsProvider,
    );
    return AsyncValueWidget<List<SowingWorkshop>>(
      value: sowingWorkshopsAsync,
      data: (sowingWorkshops) {
        return Scaffold(
          appBar: const NavBar(),
          body: SowingWorkshopsFeedBuilder(
            sowingWorkshops: sowingWorkshops,
            sowingWorkshopBuilder: (_, sowingWorkshop, index) => SizedBox(
              width: double.infinity,
              child: ListItemContainer(
                child: ListTile(
                  title: Text(
                    sowingWorkshop.title,
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateTimeFormat.toYYYYMMDD(sowingWorkshop.createdAt),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              sowingWorkshop.description,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              sowingWorkshop.authorId,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<SowingWorkshopAction>(
                    onSelected: (SowingWorkshopAction selectedAction) async {
                      switch (selectedAction) {
                        case SowingWorkshopAction.query:
                          {
                            onSowingWorkshopSelected.call(sowingWorkshop);
                          }
                          break;
                        case SowingWorkshopAction.edit:
                          {
                            onEditSowingWorkshop.call(sowingWorkshop);
                          }
                          break;
                        case SowingWorkshopAction.delete:
                          {
                            await _handleOnDelete(sowingWorkshop, catalogService);
                          }
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<SowingWorkshopAction>(
                        value: SowingWorkshopAction.query,
                        child: PopupMenuItemText(
                          text: 'Ver'.hardcoded,
                        ),
                      ),
                      PopupMenuItem<SowingWorkshopAction>(
                        value: SowingWorkshopAction.edit,
                        child: PopupMenuItemText(
                          text: 'Editar'.hardcoded,
                        ),
                      ),
                      PopupMenuItem<SowingWorkshopAction>(
                        value: SowingWorkshopAction.delete,
                        child: PopupMenuItemText(
                          text: 'Eliminar'.hardcoded,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    onSowingWorkshopSelected.call(sowingWorkshop);
                  },
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: onCreateNewSowingWorkshop,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
