import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/shared/common_widgets/navbar.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';
import '../../../../shared/async/async_value_ui.dart';
import '../../../../shared/common_widgets/done_button.dart';
import '../../../../shared/common_widgets/input_list.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/simple_text_form_field.dart';
import '../../../../shared/common_widgets/subtitle.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/routing/routes.dart';
import '../common/image_edit_details.input.dart';
import 'catalog_record_details.input.dart';
import 'create_catalog_record.controler.dart';
import 'create_catalog_record.state.dart';
import '../common/image_selection.widget.dart';

class CreateCatalogRecordScreen extends StatelessWidget {
  const CreateCatalogRecordScreen({Key? key}) : super(key: key);

  static const commonNameKey = Key('commonName');
  static const scientificNameKey = Key('scientificName');
  static const descriptionKey = Key('description');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: _CreateCatalogRecordForm(
        onCatalogRecordCreated: (catalogId) => context.pushNamed(Routes.catalog),
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
  final _node = FocusScopeNode();
  final _commonNameController = TextEditingController();
  final _scientificNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String get commonName => _commonNameController.text;
  String get scientificName => _scientificNameController.text;
  String get description => _descriptionController.text;

  List<String> _locations = [];
  List<ImageEditDetailsInput> _images = [];

  var _submitted = false;

  @override
  void dispose() {
    _node.dispose();
    _commonNameController.dispose();
    _scientificNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _focusNextInput() {
    _node.nextFocus();
  }

  void _handleOnLocationListChanged(List<String> locations) {
    _locations = locations;
  }

  void _handleOnImagesUpdated(List<ImageEditDetailsInput> images) {
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
              .map((image) => ImageEditDetailsInput(description: image.description, url: image.url))
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
      child: FocusScope(
        node: _node,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ScreenTitle(text: state.formTitle),
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
                onEditingComplete: _focusNextInput,
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
                onEditingComplete: _focusNextInput,
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
              InputListWidget(
                items: const [],
                label: 'Ingrese una ubicación donde encontrar a la especie'.hardcoded,
                onChange: _handleOnLocationListChanged,
              ),
              Subtitle(text: state.sharePhotosText),
              ImageSelectionWidget(
                images: const [],
                onImagesUpdated: _handleOnImagesUpdated,
              ),
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
      ),
    );
  }
}
