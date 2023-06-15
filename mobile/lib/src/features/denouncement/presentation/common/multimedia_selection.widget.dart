import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/src/features/denouncement/domain/denouncement.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

import 'multimedia_edit_details.input.dart';

class MultimediaSelectionWidget extends ConsumerStatefulWidget {
  const MultimediaSelectionWidget({
    Key? key,
    required this.multimediaElements,
    required this.onMultimediaElementsUpdated,
  }) : super(key: key);

  final List<DenouncementMultimedia> multimediaElements;
  final Function(List<MultimediaEditDetailsInput>) onMultimediaElementsUpdated;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MultimediaSelectionWidgetState();
}

class _MultimediaSelectionWidgetState extends ConsumerState<MultimediaSelectionWidget> {
  final List<MultimediaEditDetailsInput> _multimediaElements = [];

  @override
  void initState() {
    for (var multimedia in widget.multimediaElements) {
      _multimediaElements.add(
        MultimediaEditDetailsInput(
          uri: multimedia.uri,
          description: multimedia.description,
          submittedAt: multimedia.submittedAt,
        ),
      );
    }
    super.initState();
  }

  void _showModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MultimediaSelectionModal(
          onSelectMultimedia: (String multimediaPath, String description) {
            setState(() {
              _multimediaElements
                  .add(MultimediaEditDetailsInput(uri: multimediaPath, description: description));
            });
            widget.onMultimediaElementsUpdated(_multimediaElements);
            context.pop();
          },
          onRemoveMultimedia: () {
            context.pop();
          },
        );
      },
    );
  }

  void _showEditModal(int index, MultimediaEditDetailsInput multimediaItem) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MultimediaSelectionModal(
            initialMultimediaPath: multimediaItem.uri,
            initialDescription: multimediaItem.description,
            onSelectMultimedia: (String imagePath, String description) {
              setState(() {
                multimediaItem.uri = imagePath;
                multimediaItem.description = description;
              });
              widget.onMultimediaElementsUpdated(_multimediaElements);
              context.pop();
            },
            onRemoveMultimedia: () {
              _removeMultimedia(index);
              widget.onMultimediaElementsUpdated(_multimediaElements);
              context.pop();
            });
      },
    );
  }

  void _removeMultimedia(int index) {
    setState(() {
      _multimediaElements.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: _multimediaElements.length,
          itemBuilder: (BuildContext context, int index) {
            final MultimediaEditDetailsInput multimediaItem = _multimediaElements[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(multimediaItem.uri),
                ),
                title: Text(multimediaItem.description),
                onTap: () => _showEditModal(index, multimediaItem),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeMultimedia(index),
                ),
              ),
            );
          },
        ),
        gapH16,
        Card(
          child: ListTile(
            leading: const Icon(Icons.add),
            title: Text(
              'Añadir elemento multimedia'.hardcoded,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: _showModal,
          ),
        ),
      ],
    );
  }
}

class MultimediaSelectionModal extends ConsumerStatefulWidget {
  final String? initialMultimediaPath;
  final String? initialDescription;
  final Function(String, String) onSelectMultimedia;
  final Function onRemoveMultimedia;

  const MultimediaSelectionModal({
    Key? key,
    this.initialMultimediaPath,
    this.initialDescription,
    required this.onSelectMultimedia,
    required this.onRemoveMultimedia,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MultimediaSelectionModalState();
}

class _MultimediaSelectionModalState extends ConsumerState<MultimediaSelectionModal> {
  late String _multimediaPath;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _multimediaPath = widget.initialMultimediaPath ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectMultimedia() async {
    final picker = ImagePicker();
    final pickedMultimedia = await picker.pickImage(source: ImageSource.gallery);
    if (pickedMultimedia != null) {
      setState(() {
        _multimediaPath = pickedMultimedia.path;
      });
    }
  }

  void _submitMultimedia() async {
    widget.onSelectMultimedia(_multimediaPath, _descriptionController.text);
  }

  void _removeMultimedia() {
    setState(() {
      _multimediaPath = '';
      _descriptionController.text = '';
    });
    widget.onRemoveMultimedia();
  }

  void _toggleFavorite() {
    // Implementa la lógica para marcar la imagen como favorita
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: insetsAll16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: () async {
                    await _selectMultimedia();
                  }),
              Expanded(
                child: Text(
                  _multimediaPath,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          gapH16,
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: 'Descripción de la evidencia'.hardcoded,
            ),
          ),
          gapH16,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(icon: const Icon(Icons.check), onPressed: _submitMultimedia),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _removeMultimedia,
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
