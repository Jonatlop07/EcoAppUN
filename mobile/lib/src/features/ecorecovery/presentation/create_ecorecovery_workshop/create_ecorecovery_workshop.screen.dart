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
import 'create_ecorecovery_workshop.controller.dart';
import 'create_ecorecovery_workshop.state.dart';
import 'ecorecovery_workshop_details.input.dart';

class CreateEcorecoveryWorkshopScreen extends StatelessWidget {
  const CreateEcorecoveryWorkshopScreen({Key? key}) : super(key: key);

  static const titleKey = Key('title');
  static const dateKey = Key('date');
  static const startTimeKey = Key('startTime');
  static const endTimeKey = Key('endTime');
  static const descriptionKey = Key('description');
  static const meetupPointKey = Key('meetupPoint');
  static const organizersKey = Key('organizers');
  static const objectivesKey = Key('objectives ');
  static const instructionsKey = Key('instructions ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: _CreateEcorecoveryWorkshopForm(
        onEcorecoveryWorkshopCreated: (ecorecoveryWorkshopId) =>
            context.pushNamed(Routes.ecorecoveryWorkshops),
      ),
    );
  }
}

class _CreateEcorecoveryWorkshopForm extends ConsumerStatefulWidget {
  const _CreateEcorecoveryWorkshopForm({
    Key? key,
    required this.onEcorecoveryWorkshopCreated,
  }) : super(key: key);

  final Function(String) onEcorecoveryWorkshopCreated;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateEcorecoveryWorkshopFormState();
}

class _CreateEcorecoveryWorkshopFormState extends ConsumerState<_CreateEcorecoveryWorkshopForm> {
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
  List<String> _objectives = [];

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

  void _handleOnChangeObjectives(List<String> objectives) {
    _objectives = objectives;
  }

  void _handleOnChangeOrganizers(List<String> organizers) {
    _organizers = organizers;
  }

  Future<void> _submit(CreateEcorecoveryWorkshopState state) async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(createEcorecoveryWorkshopControllerProvider(null).notifier);
      final success = await controller.submit(
        EcorecoveryWorkshopDetailsInput(
          title: title,
          description: description,
          date: _date,
          startTime: _startTime,
          endTime: _endTime,
          meetupPoint: _meetupPoint,
          objectives: _objectives,
          instructions: _instructions,
          organizers: _organizers,
        ),
      );
      if (success) {
        String ecorecoveryWorkshopId = state.value as String;
        widget.onEcorecoveryWorkshopCreated.call(ecorecoveryWorkshopId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      createEcorecoveryWorkshopControllerProvider(null).select((state) => state.value),
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(createEcorecoveryWorkshopControllerProvider(null));
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
                          key: CreateEcorecoveryWorkshopScreen.titleKey,
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
                          key: CreateEcorecoveryWorkshopScreen.descriptionKey,
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
                          key: CreateEcorecoveryWorkshopScreen.dateKey,
                          label: state.dateLabelText,
                          onDateSelected: _handleOnDateChanged,
                        ),
                        gapH20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomTimeOfDayPicker(
                              key: CreateEcorecoveryWorkshopScreen.startTimeKey,
                              label: state.startTimeLabelText,
                              onTimeOfDaySelected: _handleOnStartTimeChanged,
                            ),
                            CustomTimeOfDayPicker(
                              key: CreateEcorecoveryWorkshopScreen.endTimeKey,
                              label: state.endTimeLabelText,
                              onTimeOfDaySelected: _handleOnEndTimeChanged,
                            ),
                          ],
                        ),
                        gapH16,
                        CustomDropdown(
                          key: CreateEcorecoveryWorkshopScreen.meetupPointKey,
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
                  key: CreateEcorecoveryWorkshopScreen.instructionsKey,
                  items: const [],
                  decoration: InputDecoration(
                    labelText: state.instructionsLabelText,
                    hintText: state.instructionsHintText,
                    enabled: !state.isLoading,
                  ),
                  onChange: _handleOnChangeInstructions,
                ),
                gapH16,
                InputListWidget(
                  key: CreateEcorecoveryWorkshopScreen.objectivesKey,
                  items: const [],
                  decoration: InputDecoration(
                    labelText: state.objectivesLabelText,
                    hintText: state.objectivesHintText,
                    enabled: !state.isLoading,
                  ),
                  onChange: _handleOnChangeObjectives,
                ),
                gapH16,
                InputListWidget(
                  key: CreateEcorecoveryWorkshopScreen.organizersKey,
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
