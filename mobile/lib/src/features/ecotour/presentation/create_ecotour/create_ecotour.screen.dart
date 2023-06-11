import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/shared/async/async_value_ui.dart';

import '../../../../shared/common_widgets/custom_date_picker.dart';
import '../../../../shared/common_widgets/custom_dropdown.dart';
import '../../../../shared/common_widgets/custom_text_form_field.dart';
import '../../../../shared/common_widgets/custom_time_of_day_picker.dart';
import '../../../../shared/common_widgets/done_button.dart';
import '../../../../shared/common_widgets/input_list.dart';
import '../../../../shared/common_widgets/navbar.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/common_widgets/subtitle.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../../../shared/routing/routes.dart';
import 'create_ecotour.controller.dart';
import 'create_ecotour.state.dart';
import 'ecotour_details.input.dart';

class CreateEcotourScreen extends StatelessWidget {
  const CreateEcotourScreen({Key? key}) : super(key: key);

  static const titleKey = Key('title');
  static const dateKey = Key('date');
  static const startTimeKey = Key('startTime');
  static const endTimeKey = Key('endTime');
  static const descriptionKey = Key('description');
  static const meetupPointKey = Key('meetupPoint');
  static const organizersKey = Key('organizers');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: _CreateEcotourForm(
        onEcotourCreated: (ecotourId) => context.pushNamed(Routes.ecotours),
      ),
    );
  }
}

class _CreateEcotourForm extends ConsumerStatefulWidget {
  const _CreateEcotourForm({
    Key? key,
    required this.onEcotourCreated,
  }) : super(key: key);

  final Function(String) onEcotourCreated;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateEcotourFormState();
}

class _CreateEcotourFormState extends ConsumerState<_CreateEcotourForm> {
  final List<String> options = ['Aulas', 'La Che', 'La Nacho'];

  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String get title => _titleController.text;
  String get description => _descriptionController.text;

  DateTime _date = DateTime.now();

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  String _meetupPoint = '';

  List<String> _organizers = [];
  List<String> _instructions = [];

  var _submitted = false;

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

  void _handleOnDateChanged(DateTime date) {
    _date = date;
  }

  void _handleOnStartTimeChanged(TimeOfDay startTime) {
    _startTime = startTime;
  }

  void _handleOnEndTimeChanged(TimeOfDay endTime) {
    _endTime = endTime;
  }

  void _handleOnSelectMeetupPoint(String meetupPoint) {
    _meetupPoint = meetupPoint;
  }

  void _handleOnChangeInstructions(List<String> instructions) {
    _instructions = instructions;
  }

  void _handleOnChangeOrganizers(List<String> organizers) {
    _organizers = organizers;
  }

  Future<void> _submit(CreateEcotourState state) async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(createEcotourControllerProvider(null).notifier);
      final success = await controller.submit(
        EcotourDetailsInput(
          title: title,
          description: description,
          date: _date,
          startTime: _startTime,
          endTime: _endTime,
          meetupPoint: _meetupPoint,
          instructions: _instructions,
          organizers: _organizers,
        ),
      );
      if (success) {
        String ecotourId = state.value as String;
        widget.onEcotourCreated.call(ecotourId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      createEcotourControllerProvider(null).select((state) => state.value),
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(createEcotourControllerProvider(null));
    return ResponsiveScrollableCard(
      child: FocusScope(
        node: _node,
        child: Form(
          child: Padding(
            padding: insetsAll24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ScreenTitle(text: state.formTitle),
                gapH16,
                Card(
                  child: Padding(
                    padding: insetsAll12,
                    child: Column(
                      children: [
                        Subtitle(text: state.generalDetailsSubtitle),
                        gapH4,
                        CustomTextFormField(
                          key: CreateEcotourScreen.titleKey,
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
                          key: CreateEcotourScreen.descriptionKey,
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: state.descriptionLabelText,
                            hintText: state.descriptionHintText,
                            enabled: !state.isLoading,
                          ),
                          maxLength: state.textFieldMaxLength,
                          minLines: state.textFieldMinLines,
                          maxLines: state.textFieldMaxLines,
                          validator: (description) =>
                              !_submitted ? null : state.descriptionErrorText(description ?? ''),
                        ),
                      ],
                    ),
                  ),
                ),
                gapH16,
                Card(
                  child: Padding(
                    padding: insetsAll16,
                    child: Column(
                      children: [
                        Subtitle(text: state.logisticDetailsSubtitle),
                        gapH20,
                        CustomDatePicker(
                          key: CreateEcotourScreen.dateKey,
                          label: state.dateLabelText,
                          onDateSelected: _handleOnDateChanged,
                        ),
                        gapH20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomTimeOfDayPicker(
                              key: CreateEcotourScreen.startTimeKey,
                              label: state.startTimeLabelText,
                              onTimeOfDaySelected: _handleOnStartTimeChanged,
                            ),
                            CustomTimeOfDayPicker(
                              key: CreateEcotourScreen.endTimeKey,
                              label: state.endTimeLabelText,
                              onTimeOfDaySelected: _handleOnEndTimeChanged,
                            ),
                          ],
                        ),
                        gapH16,
                        CustomDropdown(
                          key: CreateEcotourScreen.meetupPointKey,
                          label: state.meetupPointLabelText,
                          options: options,
                          onSelected: _handleOnSelectMeetupPoint,
                        ),
                      ],
                    ),
                  ),
                ),
                gapH16,
                InputListWidget(
                  key: CreateEcotourScreen.organizersKey,
                  items: const [],
                  decoration: InputDecoration(
                    labelText: state.organizersLabelText,
                    hintText: state.organizersHintText,
                    enabled: !state.isLoading,
                  ),
                  onChange: _handleOnChangeOrganizers,
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
