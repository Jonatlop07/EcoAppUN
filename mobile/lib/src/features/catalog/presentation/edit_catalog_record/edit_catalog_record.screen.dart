import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';
import '../../../../shared/common_widgets/navbar.dart';
import '../../../../shared/async/async_value_ui.dart';
import '../../../../shared/common_widgets/done_button.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/custom_text_form_field.dart';
import '../../../../shared/common_widgets/subtitle.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/routing/routes.dart';
import '../../domain/catalog.dart';
import '../common/image_edit_details.input.dart';
import '../common/image_selection.widget.dart';
import '../../../../shared/common_widgets/input_list.dart';
import 'catalog_record_edit_details.input.dart';
import 'edit_catalog_record.controler.dart';
import 'edit_catalog_record.state.dart';

class EditCatalogRecordScreen extends StatelessWidget {
  const EditCatalogRecordScreen({
    Key? key,
    required this.catalogRecord,
  }) : super(key: key);

  final CatalogRecord catalogRecord;

  static const commonNameKey = Key('commonName');
  static const scientificNameKey = Key('scientificName');
  static const descriptionKey = Key('description');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: _EditCatalogRecordForm(
        catalogRecord: catalogRecord,
        onCatalogRecordEdited: (catalogId) => context.pushNamed(
          Routes.queryCatalogRecord,
          pathParameters: {"catalogRecordId": catalogId},
        ),
      ),
    );
  }
}

class _EditCatalogRecordForm extends ConsumerStatefulWidget {
  const _EditCatalogRecordForm({
    Key? key,
    required this.catalogRecord,
    required this.onCatalogRecordEdited,
  }) : super(key: key);

  final CatalogRecord catalogRecord;
  final Function(String) onCatalogRecordEdited;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCatalogRecordFormState();
}

class _EditCatalogRecordFormState extends ConsumerState<_EditCatalogRecordForm> {
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
  void initState() {
    for (var image in widget.catalogRecord.images) {
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
    for (var location in widget.catalogRecord.locations) {
      _locations.add(location);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _commonNameController.text = widget.catalogRecord.commonName;
    _scientificNameController.text = widget.catalogRecord.scientificName;
    _descriptionController.text = widget.catalogRecord.description;
    super.didChangeDependencies();
  }

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

  Future<void> _submit(EditCatalogRecordState state) async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(editCatalogRecordControllerProvider(null).notifier);
      final success = await controller.submit(
        CatalogRecordEditDetailsInput(
          id: widget.catalogRecord.id,
          authorId: widget.catalogRecord.authorId,
          commonName: commonName,
          scientificName: scientificName,
          description: description,
          createdAt: widget.catalogRecord.createdAt,
          updatedAt: widget.catalogRecord.updatedAt,
          locations: _locations,
          images: _images
              .map(
                (image) => ImageEditDetailsInput(
                  id: image.id,
                  authorId: image.authorId,
                  authorName: image.authorName,
                  description: image.description,
                  submittedAt: image.submittedAt,
                  url: image.url,
                ),
              )
              .toList(),
        ),
      );
      if (success) {
        String catalogId = state.value as String;
        widget.onCatalogRecordEdited.call(catalogId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      editCatalogRecordControllerProvider(null).select((state) => state.value),
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(editCatalogRecordControllerProvider(null));
    return ResponsiveScrollableCard(
      child: FocusScope(
        node: _node,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: insetsAll24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ScreenTitle(text: state.formTitle),
                gapH12,
                Card(
                  child: Padding(
                    padding: insetsAll12,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          key: EditCatalogRecordScreen.commonNameKey,
                          controller: _commonNameController,
                          decoration: InputDecoration(
                            labelText: state.commonNameLabelText,
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
                        CustomTextFormField(
                          key: EditCatalogRecordScreen.scientificNameKey,
                          controller: _scientificNameController,
                          decoration: InputDecoration(
                            labelText: state.scientificNameLabelText,
                            hintText: state.scientificNameHintText,
                            enabled: !state.isLoading,
                          ),
                          maxLength: state.textFieldMaxLength,
                          minLines: state.textFieldMinLines,
                          maxLines: state.textFieldMaxLines,
                          validator: (scientificName) => !_submitted
                              ? null
                              : state.scientificNameErrorText(scientificName ?? ''),
                          onEditingComplete: _focusNextInput,
                        ),
                        CustomTextFormField(
                          key: EditCatalogRecordScreen.descriptionKey,
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: state.descriptionLabelText,
                            hintText: state.descriptionHintText,
                            enabled: !state.isLoading,
                          ),
                          maxLength: state.textFieldMaxLength,
                          minLines: state.textFieldMinLines,
                          maxLines: state.textFieldMaxLines,
                          validator: (commonName) =>
                              !_submitted ? null : state.descriptionErrorText(commonName ?? ''),
                        ),
                      ],
                    ),
                  ),
                ),
                gapH16,
                InputListWidget(
                  items: widget.catalogRecord.locations,
                  decoration: InputDecoration(
                    labelText: state.locationsLabelText,
                    hintText: state.locationsHintText,
                    enabled: !state.isLoading,
                  ),
                  onChange: _handleOnLocationListChanged,
                ),
                gapH16,
                Subtitle(text: state.sharePhotosText),
                gapH4,
                ImageSelectionWidget(
                  images: widget.catalogRecord.images,
                  onImagesUpdated: _handleOnImagesUpdated,
                ),
                gapH24,
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
      ),
    );
  }
}
