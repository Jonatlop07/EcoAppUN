import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/types/checkable_item.dart';
import '../../../../shared/async/async_value_ui.dart';
import '../../../../features/sowing/common/add_seeds.widget.dart';
import '../../../../shared/common_widgets/custom_date_picker.dart';
import '../../../../shared/common_widgets/custom_dropdown.dart';
import '../../../../shared/common_widgets/input_checklist.dart';
import '../../../../shared/common_widgets/done_button.dart';
import '../../../../shared/common_widgets/navbar.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/common_widgets/simple_text_form_field.dart';
import '../../../../shared/routing/routes.dart';
import '../../../../shared/common_widgets/input_list.dart';
import '../../domain/sowing.dart';
import '../../common/seed_edit_details.input.dart';
import 'edit_sowing_workshop.controller.dart';
import 'edit_sowing_workshop.state.dart';
import 'sowing_workshop_edit_details.input.dart';

class EditSowingWorkshopScreen extends StatelessWidget {
  const EditSowingWorkshopScreen({
    Key? key,
    required this.sowingWorkshop,
  }) : super(key: key);

  final SowingWorkshop sowingWorkshop;

  static const titleKey = Key('title');
  static const startTimeKey = Key('startTime');
  static const endTimeKey = Key('endTime');
  static const descriptionKey = Key('description');
  static const meetupPointKey = Key('meetupPoint');
  static const organizersKey = Key('organizers');
  static const objectivesKey = Key('objectives ');
  static const instructionsKey = Key('instructions ');
  static const seedsKey = Key('seeds ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: _EditSowingWorkshopForm(
        sowingWorkshop: sowingWorkshop,
        onSowingWorkshopEdited: (sowingWorkshopId) => context.pushNamed(
          Routes.querySowingWorkshop,
          pathParameters: {"sowingWorkshopId": sowingWorkshopId},
        ),
      ),
    );
  }
}

class _EditSowingWorkshopForm extends ConsumerStatefulWidget {
  const _EditSowingWorkshopForm({
    Key? key,
    required this.sowingWorkshop,
    required this.onSowingWorkshopEdited,
  }) : super(key: key);

  final SowingWorkshop sowingWorkshop;
  final Function(String) onSowingWorkshopEdited;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditSowingWorkshopFormState();
}

class _EditSowingWorkshopFormState extends ConsumerState<_EditSowingWorkshopForm> {
  final List<String> options = ['Aulas', 'La Che'];

  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String get title => _titleController.text;
  String get description => _descriptionController.text;

  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();

  String _meetupPoint = '';

  List<String> _organizers = [];
  List<String> _instructions = [];
  List<Objective> _objectives = [];

  List<SeedEditDetailsInput> _seeds = [];

  var _submitted = false;

  @override
  void initState() {
    for (var seed in widget.sowingWorkshop.seeds) {
      _seeds.add(
        SeedEditDetailsInput(
          id: seed.id,
          description: description,
          imageLink: seed.imageLink,
          availableAmount: seed.availableAmount,
        ),
      );
    }
    for (var organizer in widget.sowingWorkshop.organizers) {
      _organizers.add(organizer);
    }
    for (var instruction in widget.sowingWorkshop.instructions) {
      _instructions.add(instruction);
    }
    for (var objective in widget.sowingWorkshop.objectives) {
      _objectives.add(objective);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _titleController.text = widget.sowingWorkshop.title;
    _descriptionController.text = widget.sowingWorkshop.description;
    _startTime = widget.sowingWorkshop.startTime;
    _endTime = widget.sowingWorkshop.endTime;
    _meetupPoint = widget.sowingWorkshop.meetupPoint;
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

  void _handleOnStartTimeChanged(DateTime startTime) {
    _startTime = startTime;
  }

  void _handleOnEndTimeChanged(DateTime endTime) {
    _endTime = endTime;
  }

  void _handleOnSelectMeetupPoint(String meetupPoint) {
    _meetupPoint = meetupPoint;
  }

  void _handleOnSeedsUpdate(List<SeedEditDetailsInput> seeds) {
    _seeds = seeds;
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

  Future<void> _submit(EditSowingWorkshopState state) async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(editSowingWorkshopControllerProvider(null).notifier);
      final success = await controller.submit(
        SowingWorkshopEditDetailsInput(
          id: widget.sowingWorkshop.id,
          authorId: widget.sowingWorkshop.authorId,
          createdAt: widget.sowingWorkshop.createdAt,
          updatedAt: widget.sowingWorkshop.updatedAt,
          title: title,
          description: description,
          startTime: _startTime,
          endTime: _endTime,
          meetupPoint: _meetupPoint,
          objectives: _objectives,
          instructions: _instructions,
          organizers: _organizers,
          seeds: _seeds,
        ),
      );
      if (success) {
        String sowingWorkshopId = state.value as String;
        widget.onSowingWorkshopEdited.call(sowingWorkshopId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      editSowingWorkshopControllerProvider(null).select((state) => state.value),
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(editSowingWorkshopControllerProvider(null));
    return ResponsiveScrollableCard(
      child: FocusScope(
        node: _node,
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ScreenTitle(
                text: state.formTitle,
              ),
              SimpleTextFormField(
                key: EditSowingWorkshopScreen.titleKey,
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: state.titleHintText,
                  enabled: !state.isLoading,
                ),
                maxLength: state.textFieldMaxLength,
                minLines: state.textFieldMinLines,
                maxLines: state.textFieldMaxLines,
                validator: (title) => !_submitted ? null : state.titleErrorText(title ?? ''),
                onEditingComplete: _focusNextInput,
              ),
              SimpleTextFormField(
                key: EditSowingWorkshopScreen.descriptionKey,
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: state.descriptionHintText,
                  enabled: !state.isLoading,
                ),
                maxLength: state.textFieldMaxLength,
                minLines: state.textFieldMinLines,
                maxLines: state.textFieldMaxLines,
                validator: (description) =>
                    !_submitted ? null : state.descriptionErrorText(description ?? ''),
                onEditingComplete: _focusNextInput,
              ),
              CustomDatePicker(
                key: EditSowingWorkshopScreen.startTimeKey,
                initialDate: _startTime,
                label: state.startTimeLabelText,
                onDateSelected: _handleOnStartTimeChanged,
              ),
              CustomDatePicker(
                key: EditSowingWorkshopScreen.endTimeKey,
                initialDate: _endTime,
                label: state.endTimeLabelText,
                onDateSelected: _handleOnEndTimeChanged,
              ),
              CustomDropdown(
                key: EditSowingWorkshopScreen.meetupPointKey,
                initialOptionIndex: _getMeetupPointOptionIndex(_meetupPoint),
                options: options,
                onSelected: _handleOnSelectMeetupPoint,
              ),
              AddSeedWidget(
                seeds: _seeds,
                onSeedsUpdated: _handleOnSeedsUpdate,
              ),
              InputListWidget(
                key: EditSowingWorkshopScreen.instructionsKey,
                items: _instructions,
                label: state.instructionsLabelText,
                onChange: _handleOnChangeInstructions,
              ),
              InputChecklistWidget(
                key: EditSowingWorkshopScreen.objectivesKey,
                items: _objectives
                    .map(
                      (objective) => CheckableItem(
                        description: objective.description,
                        isChecked: objective.isAchieved,
                      ),
                    )
                    .toList(),
                label: state.objectivesLabelText,
                onChange: _handleOnChangeObjectives,
              ),
              InputListWidget(
                key: EditSowingWorkshopScreen.organizersKey,
                items: _organizers,
                label: state.organizersLabelText,
                onChange: _handleOnChangeOrganizers,
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
