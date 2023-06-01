import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/async/async_value_ui.dart';
import '../../../../shared/common_widgets/done_button.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/simple_text_form_field.dart';
import '../../../../shared/common_widgets/subsection_text.dart';
import '../../../../shared/common_widgets/subsection_title.dart';
import '../../../../shared/routing/route_paths.dart';
import 'catalog_record_details.input.dart';
import 'create_catalog_record.controler.dart';
import 'create_catalog_record.state.dart';
import 'image_selection.widget.dart';
import 'location_list.widget.dart';

class CreateCatalogRecordScreen extends StatelessWidget {
  const CreateCatalogRecordScreen({Key? key}) : super(key: key);

  static const titleKey = Key('title');
  static const commonNameKey = Key('commonName');
  static const scientificNameKey = Key('scientificName');
  static const descriptionKey = Key('description');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _CreateCatalogRecordForm(
        onCatalogRecordCreated: (catalogId) => context.go('$RoutePaths.catalog/$catalogId'),
      ),
    );
  }
}

class _CreateCatalogRecordForm extends ConsumerStatefulWidget {
  const _CreateCatalogRecordForm({
    Key? key,
    required this.onCatalogRecordCreated,
  }) : super(key: key);

  final Function(String) onCatalogRecordCreated;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateCatalogRecordFormState();
}

class _CreateCatalogRecordFormState extends ConsumerState<_CreateCatalogRecordForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _commonNameController = TextEditingController();
  final _scientificNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String get commonName => _commonNameController.text;
  String get scientificName => _scientificNameController.text;
  String get description => _descriptionController.text;

  List<String> _locations = [];
  List<ImageItem> _images = [];

  var _submitted = false;

  @override
  void dispose() {
    _titleController.dispose();
    _commonNameController.dispose();
    _scientificNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void handleOnLocationListChanged(List<String> locations) {
    _locations = locations;
  }

  void handleOnImagesUpdated(List<ImageItem> images) {
    _images = images;
  }

  Future<void> _submit(CreateCatalogRecordState state) async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(createCatalogRecordControllerProvider(null).notifier);
      final success = await controller.submit(
        CatalogRecordDetailsInput(
          commonName: commonName,
          scientificName: scientificName,
          description: description,
          locations: _locations,
          images: _images
              .map((image) => ImageDetailsInput(description: image.description, url: image.url))
              .toList(),
        ),
      );
      if (success) {
        String catalogId = state.value as String;
        widget.onCatalogRecordCreated.call(catalogId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      createCatalogRecordControllerProvider(null).select((state) => state.value),
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(createCatalogRecordControllerProvider(null));
    return ResponsiveScrollableCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SubsectionTitle(text: state.formTitle),
            SimpleTextFormField(
              key: CreateCatalogRecordScreen.commonNameKey,
              controller: _commonNameController,
              decoration: InputDecoration(
                hintText: state.commonNameHintText,
                enabled: !state.isLoading,
              ),
              maxLength: state.textFieldMaxLength,
              minLines: state.textFieldMinLines,
              maxLines: state.textFieldMaxLines,
              validator: (commonName) =>
                  !_submitted ? null : state.commonNameErrorText(commonName ?? ''),
            ),
            SimpleTextFormField(
              key: CreateCatalogRecordScreen.scientificNameKey,
              controller: _scientificNameController,
              decoration: InputDecoration(
                hintText: state.scientificNameHintText,
                enabled: !state.isLoading,
              ),
              maxLength: state.textFieldMaxLength,
              minLines: state.textFieldMinLines,
              maxLines: state.textFieldMaxLines,
              validator: (scientificName) =>
                  !_submitted ? null : state.scientificNameErrorText(scientificName ?? ''),
            ),
            SimpleTextFormField(
              key: CreateCatalogRecordScreen.titleKey,
              controller: _titleController,
              decoration: InputDecoration(
                hintText: state.titleHintText,
                enabled: !state.isLoading,
              ),
              maxLength: state.textFieldMaxLength,
              minLines: state.textFieldMinLines,
              maxLines: state.textFieldMaxLines,
              validator: (title) => !_submitted ? null : state.titleErrorText(title ?? ''),
            ),
            SimpleTextFormField(
              key: CreateCatalogRecordScreen.descriptionKey,
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: state.descriptionHintText,
                enabled: !state.isLoading,
              ),
              maxLength: state.textFieldMaxLength,
              minLines: state.textFieldMinLines,
              maxLines: state.textFieldMaxLines,
              validator: (commonName) =>
                  !_submitted ? null : state.descriptionErrorText(commonName ?? ''),
            ),
            LocationListWidget(
              onChange: handleOnLocationListChanged,
            ),
            SubsectionText(text: state.sharePhotosText),
            ImageSelectionWidget(
              onImagesUpdated: handleOnImagesUpdated,
            ),
            // Sección para adjuntar fotos
            DoneButton(
              isLoading: state.isLoading,
              onPressed: state.isLoading
                  ? null
                  : () async {
                      await _submit(state);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
