import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/src/features/catalog/domain/catalog.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

import 'image_edit_details.input.dart';

class ImageSelectionWidget extends ConsumerStatefulWidget {
  const ImageSelectionWidget({
    Key? key,
    required this.images,
    required this.onImagesUpdated,
  }) : super(key: key);

  final List<CatalogRecordImage> images;
  final Function(List<ImageEditDetailsInput>) onImagesUpdated;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImageSelectionWidgetState();
}

class _ImageSelectionWidgetState extends ConsumerState<ImageSelectionWidget> {
  final List<ImageEditDetailsInput> _images = [];

  @override
  void initState() {
    super.initState();
    for (var image in widget.images) {
      _images.add(
        ImageEditDetailsInput(
          id: image.id,
          authorId: image.authorId,
          authorName: image.authorName,
          description: image.description,
          url: image.url,
          submittedAt: image.submittedAt,
        ),
      );
    }
  }

  void _showModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ImageSelectionModal(
          onSelectImage: (String imagePath, String description) {
            setState(() {
              _images.add(ImageEditDetailsInput(url: imagePath, description: description));
            });
            widget.onImagesUpdated(_images);
            context.pop();
          },
          onRemoveImage: () {
            context.pop();
          },
        );
      },
    );
  }

  void _showEditModal(int index, ImageEditDetailsInput imageItem) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ImageSelectionModal(
            initialImagePath: imageItem.url,
            initialDescription: imageItem.description,
            onSelectImage: (String imagePath, String description) {
              setState(() {
                imageItem.url = imagePath;
                imageItem.description = description;
              });
              widget.onImagesUpdated(_images);
              context.pop();
            },
            onRemoveImage: () {
              _removeImage(index);
              widget.onImagesUpdated(_images);
              context.pop();
            });
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: _images.length,
          itemBuilder: (BuildContext context, int index) {
            final ImageEditDetailsInput imageItem = _images[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(imageItem.url),
                ),
                title: Text(imageItem.description),
                onTap: () => _showEditModal(index, imageItem),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeImage(index),
                ),
              ),
            );
          },
        ),
        gapH16,
        Card(
          child: ListTile(
            leading: const Icon(Icons.add),
            title: Text('Añadir imagen'.hardcoded),
            onTap: _showModal,
          ),
        ),
      ],
    );
  }
}

class ImageSelectionModal extends ConsumerStatefulWidget {
  final String? initialImagePath;
  final String? initialDescription;
  final Function(String, String) onSelectImage;
  final Function onRemoveImage;

  const ImageSelectionModal({
    Key? key,
    this.initialImagePath,
    this.initialDescription,
    required this.onSelectImage,
    required this.onRemoveImage,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImageSelectionModalState();
}

class _ImageSelectionModalState extends ConsumerState<ImageSelectionModal> {
  late String _imagePath;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _imagePath = widget.initialImagePath ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imagePath = pickedImage.path;
      });
    }
  }

  void _submitImage() async {
    widget.onSelectImage(_imagePath, _descriptionController.text);
  }

  void _removeImage() {
    setState(() {
      _imagePath = '';
      _descriptionController.text = '';
    });
    widget.onRemoveImage();
  }

  void _toggleFavorite() {
    // Implementa la lógica para marcar la imagen como favorita
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: () async {
                    await _selectImage();
                  }),
              Expanded(
                child: Text(
                  _imagePath,
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
              hintText: 'Descripción de la imagen'.hardcoded,
            ),
          ),
          gapH16,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(icon: const Icon(Icons.check), onPressed: _submitImage),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _removeImage,
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
