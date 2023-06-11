import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/common_widgets/popup_menu_item_text.dart';
import '../../../../shared/common_widgets/list_item_container.dart';
import '../../../../shared/common_widgets/navbar.dart';
import '../../../../shared/time/datetime.format.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/common_widgets/async_value.dart';
import '../../data/ecorecovery_service.dart';
import '../../domain/ecorecovery.dart';
import '../common/ecorecovery_workshops_feed.builder.dart';

enum EcorecoveryWorkshopAction { query, edit, delete }

class EcorecoveryWorkshopsFeedScreen extends ConsumerWidget {
  const EcorecoveryWorkshopsFeedScreen({
    Key? key,
    required this.onEcorecoveryWorkshopSelected,
    required this.onEditEcorecoveryWorkshop,
    required this.onDeleteEcorecoveryWorkshop,
    required this.onCreateNewEcorecoveryWorkshop,
  }) : super(key: key);

  final Function(EcorecoveryWorkshop) onEcorecoveryWorkshopSelected;
  final Function(EcorecoveryWorkshop) onEditEcorecoveryWorkshop;
  final Function(String) onDeleteEcorecoveryWorkshop;
  final Function() onCreateNewEcorecoveryWorkshop;

  Future<void> _handleOnDelete(
    EcorecoveryWorkshop ecorecoveryWorkshop,
    EcorecoveryService catalogService,
  ) async {
    await catalogService.deleteWorkshop(ecorecoveryWorkshop.id);
    onDeleteEcorecoveryWorkshop.call(ecorecoveryWorkshop.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EcorecoveryService catalogService = ref.watch(ecorecoveryServiceProvider);
    AsyncValue<List<EcorecoveryWorkshop>> ecorecoveryWorkshopsAsync = ref.watch(
      getAllEcorecoveryWorkshopsProvider,
    );
    return AsyncValueWidget<List<EcorecoveryWorkshop>>(
      value: ecorecoveryWorkshopsAsync,
      data: (ecorecoveryWorkshops) {
        return Scaffold(
          appBar: const NavBar(),
          body: EcorecoveryWorkshopsFeedBuilder(
            ecorecoveryWorkshops: ecorecoveryWorkshops,
            ecorecoveryWorkshopBuilder: (_, ecorecoveryWorkshop, index) => SizedBox(
              width: double.infinity,
              child: ListItemContainer(
                child: ListTile(
                  title: Text(
                    ecorecoveryWorkshop.title,
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateTimeFormat.toYYYYMMDD(ecorecoveryWorkshop.createdAt),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ecorecoveryWorkshop.description,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ecorecoveryWorkshop.authorId,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<EcorecoveryWorkshopAction>(
                    onSelected: (EcorecoveryWorkshopAction selectedAction) async {
                      switch (selectedAction) {
                        case EcorecoveryWorkshopAction.query:
                          {
                            onEcorecoveryWorkshopSelected.call(ecorecoveryWorkshop);
                          }
                          break;
                        case EcorecoveryWorkshopAction.edit:
                          {
                            onEditEcorecoveryWorkshop.call(ecorecoveryWorkshop);
                          }
                          break;
                        case EcorecoveryWorkshopAction.delete:
                          {
                            await _handleOnDelete(ecorecoveryWorkshop, catalogService);
                          }
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<EcorecoveryWorkshopAction>(
                        value: EcorecoveryWorkshopAction.query,
                        child: PopupMenuItemText(
                          text: 'Ver'.hardcoded,
                        ),
                      ),
                      PopupMenuItem<EcorecoveryWorkshopAction>(
                        value: EcorecoveryWorkshopAction.edit,
                        child: PopupMenuItemText(
                          text: 'Editar'.hardcoded,
                        ),
                      ),
                      PopupMenuItem<EcorecoveryWorkshopAction>(
                        value: EcorecoveryWorkshopAction.delete,
                        child: PopupMenuItemText(
                          text: 'Eliminar'.hardcoded,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    onEcorecoveryWorkshopSelected.call(ecorecoveryWorkshop);
                  },
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: onCreateNewEcorecoveryWorkshop,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
