import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/types/checkable_item.dart';

import '../constants/app.sizes.dart';

class InputChecklistWidget extends ConsumerStatefulWidget {
  const InputChecklistWidget({
    Key? key,
    required this.items,
    required this.label,
    required this.onChange,
  }) : super(key: key);

  final List<CheckableItem> items;
  final String label;
  final Function(List<CheckableItem>) onChange;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InputChecklistWidgetState();
}

class _InputChecklistWidgetState extends ConsumerState<InputChecklistWidget> {
  final TextEditingController _addItemController = TextEditingController();
  final TextEditingController _editItemController = TextEditingController();
  final List<CheckableItem> _items = [];
  int _editingIndex = -1;

  @override
  void initState() {
    for (var item in widget.items) {
      _items.add(item);
    }
    super.initState();
  }

  @override
  void dispose() {
    _addItemController.dispose();
    _editItemController.dispose();
    super.dispose();
  }

  void _addItem(String itemDescription) {
    if (itemDescription.isNotEmpty) {
      setState(() {
        _items.add(
          CheckableItem(
            description: itemDescription,
            isChecked: false,
          ),
        );
        _addItemController.clear();
      });
      widget.onChange(_items);
    }
  }

  void _onCheckItem(int index, bool isChecked) {
    setState(() {
      _items[index].isChecked = isChecked;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    widget.onChange(_items);
  }

  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      _editItemController.text = _items[index].description;
    });
  }

  void _finishEditing() {
    setState(() {
      if (_editingIndex >= 0 && _editingIndex < _items.length) {
        _items[_editingIndex].description = _editItemController.text;
        _editingIndex = -1;
        _editItemController.clear();
      }
    });
    widget.onChange(_items);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _addItemController,
                decoration: InputDecoration(
                  hintText: widget.label,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _addItem(_addItemController.text);
                    },
                    child: const Icon(Icons.send),
                  ),
                ),
                onSubmitted: (value) {
                  _addItem(value);
                },
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
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        _finishEditing();
                      },
                    ),
                  )
                : ListTile(
                    title: Text(_items[index].description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: _items[index].isChecked,
                          onChanged: (bool? isChecked) {
                            _onCheckItem(index, isChecked!);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _startEditing(index);
                          },
                        ),
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
    );
  }
}
