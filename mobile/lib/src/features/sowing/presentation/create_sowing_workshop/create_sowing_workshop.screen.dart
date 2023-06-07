import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/async/async_value_ui.dart';
import '../../../../features/sowing/common/add_seeds.widget.dart';
import '../../../../shared/common_widgets/custom_date_picker.dart';
import '../../../../shared/common_widgets/custom_dropdown.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/common_widgets/done_button.dart';
import '../../../../shared/common_widgets/navbar.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/common_widgets/simple_text_form_field.dart';
import '../../../../shared/routing/routes.dart';
import '../../../../shared/common_widgets/input_list.widget.dart';
import '../../common/seed_edit_details.input.dart';
import 'create_sowing_workshop.controller.dart';
import 'create_sowing_workshop.state.dart';
import 'sowing_workshop_details.input.dart';

class CreateSowingWorkshopScreen extends StatelessWidget {
  const CreateSowingWorkshopScreen({Key? key}) : super(key: key);

  static const titleKey = Key('title');
  static const startTimeKey = Key('startTime');
  static const endTimeKey = Key('endTime');
  static const descriptionKey = Key('description');
  static const meetingPointKey = Key('meetingPoint');
  static const organizersKey = Key('organizers');
  static const objectivesKey = Key('objectives ');
  static const instructionsKey = Key('instructions ');
  static const seedsKey = Key('seeds ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: _CreateSowingWorkshopForm(
        onSowingWorkshopCreated: (sowingWorkshopId) => context.pushNamed(Routes.sowingWorkshops),
      ),
    );
  }
}

class _CreateSowingWorkshopForm extends ConsumerStatefulWidget {
  const _CreateSowingWorkshopForm({
    Key? key,
    required this.onSowingWorkshopCreated,
  }) : super(key: key);

  final Function(String) onSowingWorkshopCreated;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateSowingWorkshopFormState();
}

class _CreateSowingWorkshopFormState extends ConsumerState<_CreateSowingWorkshopForm> {
  final List<String> options = ['Aulas', 'La Che'];

  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String get title => _titleController.text;
  String get description => _descriptionController.text;

  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();

  String _meetingPoint = '';

  List<String> _organizers = [];
  List<String> _instructions = [];
  List<String> _objectives = [];

  List<SeedEditDetailsInput> _seeds = [];

  var _submitted = false;

  @override
  void dispose() {
    _node.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void focusNextInput() {
    _node.nextFocus();
  }

  void handleOnStartTimeChanged(DateTime startTime) {
    _startTime = startTime;
  }

  void handleOnEndTimeChanged(DateTime endTime) {
    _endTime = endTime;
  }

  void handleOnSelectMeetingPoint(String meetingPoint) {
    _meetingPoint = meetingPoint;
  }

  void handleOnSeedsUpdate(List<SeedEditDetailsInput> seeds) {
    _seeds = seeds;
  }

  void handleOnChangeInstructions(List<String> instructions) {
    _instructions = instructions;
  }

  void handleOnChangeObjectives(List<String> objectives) {
    _objectives = objectives;
  }

  void handleOnChangeOrganizers(List<String> organizers) {
    _organizers = organizers;
  }

  Future<void> _submit(CreateSowingWorkshopState state) async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(createSowingWorkshopControllerProvider(null).notifier);
      final success = await controller.submit(
        SowingWorkshopDetailsInput(
          title: title,
          description: description,
          startTime: _startTime,
          endTime: _endTime,
          meetingPoint: _meetingPoint,
          objectives: _objectives,
          instructions: _instructions,
          organizers: _organizers,
          seeds: _seeds,
        ),
      );
      if (success) {
        String sowingWorkshopId = state.value as String;
        widget.onSowingWorkshopCreated.call(sowingWorkshopId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      createSowingWorkshopControllerProvider(null).select((state) => state.value),
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(createSowingWorkshopControllerProvider(null));
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
                key: CreateSowingWorkshopScreen.titleKey,
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: state.titleHintText,
                  enabled: !state.isLoading,
                ),
                maxLength: state.textFieldMaxLength,
                minLines: state.textFieldMinLines,
                maxLines: state.textFieldMaxLines,
                validator: (title) => !_submitted ? null : state.titleErrorText(title ?? ''),
                onEditingComplete: focusNextInput,
              ),
              SimpleTextFormField(
                key: CreateSowingWorkshopScreen.descriptionKey,
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
                onEditingComplete: focusNextInput,
              ),
              CustomDatePicker(
                key: CreateSowingWorkshopScreen.startTimeKey,
                label: 'Inicia el'.hardcoded,
                onDateSelected: handleOnStartTimeChanged,
              ),
              CustomDatePicker(
                key: CreateSowingWorkshopScreen.endTimeKey,
                label: 'Finaliza el'.hardcoded,
                onDateSelected: handleOnEndTimeChanged,
              ),
              CustomDropdown(
                key: CreateSowingWorkshopScreen.meetingPointKey,
                options: options,
                onSelected: handleOnSelectMeetingPoint,
              ),
              AddSeedWidget(
                seeds: const [],
                onSeedsUpdated: handleOnSeedsUpdate,
              ),
              InputListWidget(
                key: CreateSowingWorkshopScreen.instructionsKey,
                items: const [],
                label: 'Añade una instrucción a seguir'.hardcoded,
                onChange: handleOnChangeInstructions,
              ),
              InputListWidget(
                key: CreateSowingWorkshopScreen.objectivesKey,
                items: const [],
                label: 'Añade un objetivo del taller'.hardcoded,
                onChange: handleOnChangeObjectives,
              ),
              InputListWidget(
                key: CreateSowingWorkshopScreen.organizersKey,
                items: const [],
                label: 'Agrega un organizador'.hardcoded,
                onChange: handleOnChangeOrganizers,
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
