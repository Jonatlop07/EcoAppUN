import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/common_widgets/custom_dropdown.dart';

import '../constants/app.sizes.dart';

class DropdownInputListWidget extends ConsumerStatefulWidget {
  const DropdownInputListWidget({
    Key? key,
    required this.items,
    this.initialOptionIndex,
    required this.options,
    required this.decoration,
    required this.onChange,
  }) : super(key: key);

  final List<String> items;
  final int? initialOptionIndex;
  final List<String> options;
  final InputDecoration decoration;
  final Function(List<String>) onChange;

  static const dropdownKey = Key('drowpdown');

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DropdownInputListWidgetState();
}

class _DropdownInputListWidgetState extends ConsumerState<DropdownInputListWidget> {
  final TextEditingController _editItemController = TextEditingController();

  String _selectedItem = '';

  final List<String> _items = [];
  int _editingIndex = -1;

  @override
  void initState() {
    for (var item in widget.items) {
      _items.add(item);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _selectedItem = widget.options[widget.initialOptionIndex ?? 0];
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _editItemController.dispose();
    super.dispose();
  }

  void _handleOnSelectedItem(String? item) {
    if (item != null) {
      setState(() {
        _selectedItem = item;
      });
    }
  }

  void _addItem() {
    if (!_items.contains(_selectedItem)) {
      setState(() {
        _items.add(_selectedItem);
      });
      widget.onChange(_items);
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    widget.onChange(_items);
  }

  void _finishEditing() {
    setState(() {
      if (_editingIndex >= 0 && _editingIndex < _items.length) {
        _items[_editingIndex] = _editItemController.text;
        _editingIndex = -1;
        _editItemController.clear();
      }
    });
    widget.onChange(_items);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: insetsH16,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomDropdown(
                    key: DropdownInputListWidget.dropdownKey,
                    label: widget.decoration.labelText!,
                    options: widget.options,
                    initialOptionIndex: widget.initialOptionIndex,
                    onSelected: _handleOnSelectedItem,
                    trailing: IconButton(
                      onPressed: _addItem,
                      icon: const Icon(Icons.send),
                    ),
                  ),
                ),
              ],
            ),
            gapH12,
            ListView.builder(
              shrinkWrap: true,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final isEditing = _editingIndex == index;
                return isEditing
                    ? ListTile(
                        title: TextField(
                          controller: _editItemController,
                          autofocus: true,
                          onSubmitted: (_) {
                            _finishEditing();
                          },
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            _finishEditing();
                          },
                        ),
                      )
                    : ListTile(
                        title: Text(
                          _items[index],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _removeItem(index);
                              },
                            ),
                          ],
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
