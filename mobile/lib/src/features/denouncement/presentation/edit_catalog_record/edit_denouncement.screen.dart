import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/features/denouncement/presentation/common/multimedia_edit_details.input.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';
import '../../../../shared/common_widgets/custom_date_picker.dart';
import '../../../../shared/common_widgets/navbar.dart';
import '../../../../shared/async/async_value_ui.dart';
import '../../../../shared/common_widgets/done_button.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/custom_text_form_field.dart';
import '../../../../shared/common_widgets/subtitle.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/routing/routes.dart';
import '../../domain/denouncement.dart';
import '../common/multimedia_selection.widget.dart';
import 'denouncement_edit_details.input.dart';
import 'edit_denouncement.controler.dart';
import 'edit_denouncement.state.dart';

class EditDenouncementScreen extends StatelessWidget {
  const EditDenouncementScreen({
    Key? key,
    required this.denouncement,
  }) : super(key: key);

  final Denouncement denouncement;

  static const titleKey = Key('title');
  static const descriptionKey = Key('description');
  static const initialDateKey = Key('initialDate');
  static const finalDateKey = Key('finalDate');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: _EditDenouncementForm(
        denouncement: denouncement,
        onDenouncementEdited: (denouncementId) => context.pushNamed(
          Routes.queryDenouncement,
          pathParameters: {"denouncementId": denouncementId},
        ),
      ),
    );
  }
}

class _EditDenouncementForm extends ConsumerStatefulWidget {
  const _EditDenouncementForm({
    Key? key,
    required this.denouncement,
    required this.onDenouncementEdited,
  }) : super(key: key);

  final Denouncement denouncement;
  final Function(String) onDenouncementEdited;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditDenouncementFormState();
}

class _EditDenouncementFormState extends ConsumerState<_EditDenouncementForm> {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String get title => _titleController.text;
  String get description => _descriptionController.text;

  DateTime _initialDate = DateTime.now();
  DateTime _finalDate = DateTime.now();

  List<MultimediaEditDetailsInput> _multimediaElements = [];

  var _submitted = false;

  @override
  void initState() {
    for (var multimediaElement in widget.denouncement.multimediaElements) {
      _multimediaElements.add(
        MultimediaEditDetailsInput(
          description: multimediaElement.description,
          uri: multimediaElement.uri,
          submittedAt: multimediaElement.submittedAt,
        ),
      );
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _titleController.text = widget.denouncement.title;
    _descriptionController.text = widget.denouncement.description;
    _initialDate = widget.denouncement.initialDate;
    _finalDate = widget.denouncement.finalDate;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _node.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _focusNextInput() {
    _node.nextFocus();
  }

  void _handleOnInitialDateChanged(DateTime date) {
    _initialDate = date;
  }

  void _handleOnFinalDateChanged(DateTime date) {
    _finalDate = date;
  }

  void _handleOnMultimediaElementsUpdated(List<MultimediaEditDetailsInput> multimediaElements) {
    _multimediaElements = multimediaElements;
  }

  Future<void> _submit(EditDenouncementState state) async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(editDenouncementControllerProvider(null).notifier);
      final success = await controller.submit(
        DenouncementEditDetailsInput(
          id: widget.denouncement.id,
          denouncerId: widget.denouncement.denouncerId,
          title: title,
          description: description,
          createdAt: widget.denouncement.createdAt,
          updatedAt: widget.denouncement.updatedAt,
          multimediaElements: _multimediaElements
              .map(
                (multimediaElement) => MultimediaEditDetailsInput(
                  description: multimediaElement.description,
                  submittedAt: multimediaElement.submittedAt,
                  uri: multimediaElement.uri,
                ),
              )
              .toList(),
        ),
      );
      if (success) {
        String denouncementId = state.value as String;
        widget.onDenouncementEdited.call(denouncementId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      editDenouncementControllerProvider(null).select((state) => state.value),
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(editDenouncementControllerProvider(null));
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
                          key: EditDenouncementScreen.titleKey,
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: state.titleLabelText,
                            hintText: state.titleHintText,
                            enabled: !state.isLoading,
                          ),
                          maxLength: state.textFieldMaxLength,
                          minLines: state.textFieldMinLines,
                          maxLines: state.textFieldMaxLines,
                          validator: (title) =>
                              !_submitted ? null : state.titleErrorText(title ?? ''),
                          onEditingComplete: _focusNextInput,
                        ),
                        CustomTextFormField(
                          key: EditDenouncementScreen.descriptionKey,
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: state.descriptionLabelText,
                            hintText: state.descriptionHintText,
                            enabled: !state.isLoading,
                          ),
                          maxLength: state.textFieldMaxLength,
                          minLines: state.textFieldMinLines,
                          maxLines: state.textFieldMaxLines,
                          validator: (title) =>
                              !_submitted ? null : state.descriptionErrorText(title ?? ''),
                        ),
                        gapH20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomDatePicker(
                              key: EditDenouncementScreen.initialDateKey,
                              label: state.initialDateLabelText,
                              onDateSelected: _handleOnInitialDateChanged,
                            ),
                            CustomDatePicker(
                              key: EditDenouncementScreen.finalDateKey,
                              label: state.finalDateLabelText,
                              onDateSelected: _handleOnFinalDateChanged,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                gapH16,
                Subtitle(text: state.shareMediaText),
                gapH4,
                MultimediaSelectionWidget(
                  multimediaElements: widget.denouncement.multimediaElements,
                  onMultimediaElementsUpdated: _handleOnMultimediaElementsUpdated,
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
