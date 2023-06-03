import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

class LocationListWidget extends ConsumerStatefulWidget {
  const LocationListWidget({
    Key? key,
    required this.locations,
    required this.onChange,
  }) : super(key: key);

  final List<String> locations;
  final Function(List<String>) onChange;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationListWidgetState();
}

class _LocationListWidgetState extends ConsumerState<LocationListWidget> {
  final TextEditingController _addLocationController = TextEditingController();
  final TextEditingController _editLocationController = TextEditingController();
  final List<String> _locations = [];
  int _editingIndex = -1;

  @override
  void initState() {
    for (var location in widget.locations) {
      _locations.add(location);
    }
    super.initState();
  }

  @override
  void dispose() {
    _addLocationController.dispose();
    _editLocationController.dispose();
    super.dispose();
  }

  void _addLocation(String location) {
    setState(() {
      _locations.add(location);
      _addLocationController.clear();
    });
    widget.onChange(_locations);
  }

  void _removeLocation(int index) {
    setState(() {
      _locations.removeAt(index);
    });
    widget.onChange(_locations);
  }

  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      _editLocationController.text = _locations[index];
    });
  }

  void _finishEditing() {
    setState(() {
      if (_editingIndex >= 0 && _editingIndex < _locations.length) {
        _locations[_editingIndex] = _editLocationController.text;
        _editingIndex = -1;
        _editLocationController.clear();
      }
    });
    widget.onChange(_locations);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _addLocationController,
                decoration: InputDecoration(
                  hintText: 'Ingrese una ubicación'.hardcoded,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _addLocation(_addLocationController.text);
                    },
                    child: const Icon(Icons.send),
                  ),
                ),
                onSubmitted: (value) {
                  _addLocation(value);
                },
              ),
            ),
          ],
        ),
        gapH12,
        ListView.builder(
          shrinkWrap: true,
          itemCount: _locations.length,
          itemBuilder: (context, index) {
            final isEditing = _editingIndex == index;
            return isEditing
                ? ListTile(
                    title: TextField(
                      controller: _editLocationController,
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
                    title: Text(_locations[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _startEditing(index);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _removeLocation(index);
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
