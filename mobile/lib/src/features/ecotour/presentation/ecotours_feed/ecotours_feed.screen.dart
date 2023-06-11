import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/common_widgets/popup_menu_item_text.dart';
import '../../../../shared/common_widgets/list_item_container.dart';
import '../../../../shared/common_widgets/navbar.dart';
import '../../../../shared/time/datetime.format.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/common_widgets/async_value.dart';
import '../../data/ecotour_service.dart';
import '../../domain/ecotour.dart';
import '../common/ecotours_feed.builder.dart';

enum EcotourAction { query, edit, delete }

class EcotoursFeedScreen extends ConsumerWidget {
  const EcotoursFeedScreen({
    Key? key,
    required this.onEcotourSelected,
    required this.onEditEcotour,
    required this.onDeleteEcotour,
    required this.onCreateNewEcotour,
  }) : super(key: key);

  final Function(Ecotour) onEcotourSelected;
  final Function(Ecotour) onEditEcotour;
  final Function(String) onDeleteEcotour;
  final Function() onCreateNewEcotour;

  Future<void> _handleOnDelete(
    Ecotour ecotour,
    EcotourService catalogService,
  ) async {
    await catalogService.deleteEcotour(ecotour.id);
    onDeleteEcotour.call(ecotour.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EcotourService catalogService = ref.watch(ecotourServiceProvider);
    AsyncValue<List<Ecotour>> ecotoursAsync = ref.watch(
      getAllEcotoursProvider,
    );
    return AsyncValueWidget<List<Ecotour>>(
      value: ecotoursAsync,
      data: (ecotours) {
        return Scaffold(
          appBar: const NavBar(),
          body: EcotoursFeedBuilder(
            ecotours: ecotours,
            ecotourBuilder: (_, ecotour, index) => SizedBox(
              width: double.infinity,
              child: ListItemContainer(
                child: ListTile(
                  title: Text(
                    ecotour.title,
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateTimeFormat.toYYYYMMDD(ecotour.createdAt),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ecotour.description,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ecotour.authorId,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<EcotourAction>(
                    onSelected: (EcotourAction selectedAction) async {
                      switch (selectedAction) {
                        case EcotourAction.query:
                          {
                            onEcotourSelected.call(ecotour);
                          }
                          break;
                        case EcotourAction.edit:
                          {
                            onEditEcotour.call(ecotour);
                          }
                          break;
                        case EcotourAction.delete:
                          {
                            await _handleOnDelete(ecotour, catalogService);
                          }
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<EcotourAction>(
                        value: EcotourAction.query,
                        child: PopupMenuItemText(
                          text: 'Ver'.hardcoded,
                        ),
                      ),
                      PopupMenuItem<EcotourAction>(
                        value: EcotourAction.edit,
                        child: PopupMenuItemText(
                          text: 'Editar'.hardcoded,
                        ),
                      ),
                      PopupMenuItem<EcotourAction>(
                        value: EcotourAction.delete,
                        child: PopupMenuItemText(
                          text: 'Eliminar'.hardcoded,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    onEcotourSelected.call(ecotour);
                  },
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: onCreateNewEcotour,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
