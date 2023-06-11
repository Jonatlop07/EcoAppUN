import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/common_widgets/custom_time_of_day_picker.dart';
import '../../../../shared/common_widgets/subtitle.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../../../shared/types/checkable_item.dart';
import '../../../../shared/async/async_value_ui.dart';
import '../../../../shared/common_widgets/custom_date_picker.dart';
import '../../../../shared/common_widgets/custom_dropdown.dart';
import '../../../../shared/common_widgets/input_checklist.dart';
import '../../../../shared/common_widgets/done_button.dart';
import '../../../../shared/common_widgets/navbar.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/common_widgets/custom_text_form_field.dart';
import '../../../../shared/routing/routes.dart';
import '../../../../shared/common_widgets/input_list.dart';
import '../../domain/ecorecovery.dart';
import 'ecorecovery_workshop_edit_details.input.dart';
import 'edit_ecorecovery_workshop.controller.dart';
import 'edit_ecorecovery_workshop.state.dart';

class EditEcorecoveryWorkshopScreen extends StatelessWidget {
  const EditEcorecoveryWorkshopScreen({
    Key? key,
    required this.ecorecoveryWorkshop,
  }) : super(key: key);

  final EcorecoveryWorkshop ecorecoveryWorkshop;

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
      body: _EditEcorecoveryWorkshopForm(
        ecorecoveryWorkshop: ecorecoveryWorkshop,
        onEcorecoveryWorkshopEdited: (ecorecoveryWorkshopId) => context.pushNamed(
          Routes.queryEcorecoveryWorkshop,
          pathParameters: {"ecorecoveryWorkshopId": ecorecoveryWorkshopId},
        ),
      ),
    );
  }
}

class _EditEcorecoveryWorkshopForm extends ConsumerStatefulWidget {
  const _EditEcorecoveryWorkshopForm({
    Key? key,
    required this.ecorecoveryWorkshop,
    required this.onEcorecoveryWorkshopEdited,
  }) : super(key: key);

  final EcorecoveryWorkshop ecorecoveryWorkshop;
  final Function(String) onEcorecoveryWorkshopEdited;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditEcorecoveryWorkshopFormState();
}

class _EditEcorecoveryWorkshopFormState extends ConsumerState<_EditEcorecoveryWorkshopForm> {
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
  List<Objective> _objectives = [];

  var _submitted = false;

  @override
  void initState() {
    for (var organizer in widget.ecorecoveryWorkshop.organizers) {
      _organizers.add(organizer);
    }
    for (var instruction in widget.ecorecoveryWorkshop.instructions) {
      _instructions.add(instruction);
    }
    for (var objective in widget.ecorecoveryWorkshop.objectives) {
      _objectives.add(objective);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _titleController.text = widget.ecorecoveryWorkshop.title;
    _descriptionController.text = widget.ecorecoveryWorkshop.description;
    _startTime = widget.ecorecoveryWorkshop.startTime;
    _endTime = widget.ecorecoveryWorkshop.endTime;
    _meetupPoint = widget.ecorecoveryWorkshop.meetupPoint;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _node.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int _getMeetupPointOptionIndex(String meetupPoint) {
    return options.indexOf(meetupPoint);
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

  void _handleOnChangeObjectives(List<CheckableItem> objectives) {
    _objectives = objectives
        .map(
          (objective) => Objective(
            description: objective.description,
            isAchieved: objective.isChecked,
          ),
        )
        .toList();
  }

  void _handleOnChangeOrganizers(List<String> organizers) {
    _organizers = organizers;
  }

  Future<void> _submit(EditEcorecoveryWorkshopState state) async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(editEcorecoveryWorkshopControllerProvider(null).notifier);
      final success = await controller.submit(
        EcorecoveryWorkshopEditDetailsInput(
          id: widget.ecorecoveryWorkshop.id,
          authorId: widget.ecorecoveryWorkshop.authorId,
          createdAt: widget.ecorecoveryWorkshop.createdAt,
          updatedAt: widget.ecorecoveryWorkshop.updatedAt,
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
        widget.onEcorecoveryWorkshopEdited.call(ecorecoveryWorkshopId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      editEcorecoveryWorkshopControllerProvider(null).select((state) => state.value),
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(editEcorecoveryWorkshopControllerProvider(null));
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
                          key: EditEcorecoveryWorkshopScreen.titleKey,
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
                          key: EditEcorecoveryWorkshopScreen.descriptionKey,
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
                          key: EditEcorecoveryWorkshopScreen.dateKey,
                          initialDate: _date,
                          label: state.dateLabelText,
                          onDateSelected: _handleOnDateChanged,
                        ),
                        gapH20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomTimeOfDayPicker(
                              key: EditEcorecoveryWorkshopScreen.startTimeKey,
                              initialTimeOfDay: _startTime,
                              label: state.startTimeLabelText,
                              onTimeOfDaySelected: _handleOnStartTimeChanged,
                            ),
                            CustomTimeOfDayPicker(
                              key: EditEcorecoveryWorkshopScreen.endTimeKey,
                              initialTimeOfDay: _startTime,
                              label: state.endTimeLabelText,
                              onTimeOfDaySelected: _handleOnEndTimeChanged,
                            ),
                          ],
                        ),
                        gapH16,
                        CustomDropdown(
                          key: EditEcorecoveryWorkshopScreen.meetupPointKey,
                          initialOptionIndex: _getMeetupPointOptionIndex(_meetupPoint),
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
                  key: EditEcorecoveryWorkshopScreen.instructionsKey,
                  items: _instructions,
                  decoration: InputDecoration(
                    labelText: state.instructionsLabelText,
                    hintText: state.instructionsHintText,
                    enabled: !state.isLoading,
                  ),
                  onChange: _handleOnChangeInstructions,
                ),
                gapH16,
                InputChecklistWidget(
                  key: EditEcorecoveryWorkshopScreen.objectivesKey,
                  items: _objectives
                      .map(
                        (objective) => CheckableItem(
                            description: objective.description, isChecked: objective.isAchieved),
                      )
                      .toList(),
                  decoration: InputDecoration(
                    labelText: state.objectivesLabelText,
                    hintText: state.objectivesHintText,
                    enabled: !state.isLoading,
                  ),
                  onChange: _handleOnChangeObjectives,
                ),
                gapH16,
                InputListWidget(
                  key: EditEcorecoveryWorkshopScreen.organizersKey,
                  items: _organizers,
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
