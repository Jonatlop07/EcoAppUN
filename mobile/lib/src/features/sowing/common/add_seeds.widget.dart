import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/src/features/sowing/common/seed_edit_details.input.dart';
import 'package:mobile/src/features/sowing/domain/sowing.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

import '../../../shared/common_widgets/custom_text_field.dart';

class AddSeedWidget extends ConsumerStatefulWidget {
  const AddSeedWidget({
    Key? key,
    required this.seeds,
    required this.onSeedsUpdated,
  }) : super(key: key);

  final List<Seed> seeds;
  final Function(List<SeedEditDetailsInput>) onSeedsUpdated;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddSeedWidgetState();
}

class _AddSeedWidgetState extends ConsumerState<AddSeedWidget> {
  final List<SeedEditDetailsInput> _seeds = [];

  @override
  void initState() {
    for (var seed in widget.seeds) {
      _seeds.add(
        SeedEditDetailsInput(
          id: seed.id,
          description: seed.description,
          imageLink: seed.imageLink,
          availableAmount: seed.availableAmount,
        ),
      );
    }
    super.initState();
  }

  void _showModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SeedDetailsInputModal(
          onUpdateSeedDetails: (String imagePath, String description, int availableAmount) {
            setState(() {
              _seeds.add(
                SeedEditDetailsInput(
                  imageLink: imagePath,
                  description: description,
                  availableAmount: availableAmount,
                ),
              );
            });
            widget.onSeedsUpdated(_seeds);
            context.pop();
          },
          onRemoveSeed: () {
            context.pop();
          },
        );
      },
    );
  }

  void _showEditModal(int index, SeedEditDetailsInput seedItem) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SeedDetailsInputModal(
            initialImagePath: seedItem.imageLink,
            initialDescription: seedItem.description,
            onUpdateSeedDetails: (String imagePath, String description, int availableAmount) {
              setState(() {
                seedItem.imageLink = imagePath;
                seedItem.description = description;
                seedItem.availableAmount = availableAmount;
              });
              widget.onSeedsUpdated(_seeds);
              context.pop();
            },
            onRemoveSeed: () {
              _removeSeed(index);
              widget.onSeedsUpdated(_seeds);
              context.pop();
            });
      },
    );
  }

  void _removeSeed(int index) {
    setState(() {
      _seeds.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: _seeds.length,
          itemBuilder: (BuildContext context, int index) {
            final SeedEditDetailsInput seedItem = _seeds[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(seedItem.imageLink),
                ),
                title: Text(seedItem.description),
                onTap: () => _showEditModal(index, seedItem),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeSeed(index),
                ),
              ),
            );
          },
        ),
        gapH16,
        Card(
          child: ListTile(
            leading: const Icon(Icons.add),
            title: Text('Añade los detalles de un tipo de semilla'.hardcoded),
            onTap: _showModal,
          ),
        ),
      ],
    );
  }
}

class SeedDetailsInputModal extends ConsumerStatefulWidget {
  const SeedDetailsInputModal({
    Key? key,
    this.initialImagePath,
    this.initialDescription,
    this.initialAvailableAmount,
    required this.onUpdateSeedDetails,
    required this.onRemoveSeed,
  }) : super(key: key);

  final String? initialImagePath;
  final String? initialDescription;
  final String? initialAvailableAmount;
  final Function(String, String, int) onUpdateSeedDetails;
  final Function onRemoveSeed;

  static const descriptionKey = Key('description');
  static const availableAmountKey = Key('availableAmount');

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeedDetailsInputModalState();
}

class _SeedDetailsInputModalState extends ConsumerState<SeedDetailsInputModal> {
  int get textFieldMaxLength => 1024;
  int get textFieldMinLines => 1;
  int get textFieldMaxLines => 3;

  int get numberFieldMaxLength => 8;
  int get numberFieldMinLines => 1;
  int get numberFieldMaxLines => 1;

  late String _imagePath;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _availableAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _imagePath = widget.initialImagePath ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
    _descriptionController.text = widget.initialAvailableAmount ?? '0';
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _availableAmountController.dispose();
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

  void _submitSeed() async {
    widget.onUpdateSeedDetails(
      _imagePath,
      _descriptionController.text,
      int.parse(_availableAmountController.text),
    );
  }

  void _removeSeed() {
    setState(() {
      _imagePath = '';
      _descriptionController.text = '';
      _availableAmountController.text = '0';
    });
    widget.onRemoveSeed();
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
          CustomTextField(
            key: SeedDetailsInputModal.descriptionKey,
            controller: _descriptionController,
            maxLength: textFieldMaxLength,
            minLines: textFieldMinLines,
            maxLines: textFieldMaxLines,
            decoration: InputDecoration(
              hintText: 'Descripción de la imagen'.hardcoded,
            ),
          ),
          gapH16,
          CustomTextField(
            key: SeedDetailsInputModal.availableAmountKey,
            controller: _availableAmountController,
            maxLength: numberFieldMaxLength,
            minLines: numberFieldMinLines,
            maxLines: numberFieldMaxLines,
            decoration: InputDecoration(
              hintText: 'Cantidad de semillas'.hardcoded,
            ),
          ),
          gapH16,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(icon: const Icon(Icons.check), onPressed: _submitSeed),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _removeSeed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
