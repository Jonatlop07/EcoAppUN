import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/common_widgets/custom_time_of_day_picker.dart';
import '../../../../shared/common_widgets/subtitle.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../../../shared/async/async_value_ui.dart';
import '../../../../shared/common_widgets/custom_date_picker.dart';
import '../../../../shared/common_widgets/custom_dropdown.dart';
import '../../../../shared/common_widgets/done_button.dart';
import '../../../../shared/common_widgets/navbar.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/common_widgets/custom_text_form_field.dart';
import '../../../../shared/routing/routes.dart';
import '../../../../shared/common_widgets/input_list.dart';
import '../../domain/ecotour.dart';
import 'ecotour_edit_details.input.dart';
import 'edit_ecotour.controller.dart';
import 'edit_ecotour.state.dart';

class EditEcotourScreen extends StatelessWidget {
  const EditEcotourScreen({
    Key? key,
    required this.ecotour,
  }) : super(key: key);

  final Ecotour ecotour;

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
      body: _EditEcotourForm(
        ecotour: ecotour,
        onEcotourEdited: (ecotourId) => context.pushNamed(
          Routes.queryEcotour,
          pathParameters: {"ecotourId": ecotourId},
        ),
      ),
    );
  }
}

class _EditEcotourForm extends ConsumerStatefulWidget {
  const _EditEcotourForm({
    Key? key,
    required this.ecotour,
    required this.onEcotourEdited,
  }) : super(key: key);

  final Ecotour ecotour;
  final Function(String) onEcotourEdited;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditEcotourFormState();
}

class _EditEcotourFormState extends ConsumerState<_EditEcotourForm> {
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
  void initState() {
    for (var organizer in widget.ecotour.organizers) {
      _organizers.add(organizer);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _titleController.text = widget.ecotour.title;
    _descriptionController.text = widget.ecotour.description;
    _startTime = widget.ecotour.startTime;
    _endTime = widget.ecotour.endTime;
    _meetupPoint = widget.ecotour.meetupPoint;
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

  void _handleOnChangeOrganizers(List<String> organizers) {
    _organizers = organizers;
  }

  Future<void> _submit(EditEcotourState state) async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(editEcotourControllerProvider(null).notifier);
      final success = await controller.submit(
        EcotourEditDetailsInput(
          id: widget.ecotour.id,
          authorId: widget.ecotour.authorId,
          createdAt: widget.ecotour.createdAt,
          updatedAt: widget.ecotour.updatedAt,
          title: title,
          description: description,
          date: _date,
          startTime: _startTime,
          endTime: _endTime,
          meetupPoint: _meetupPoint,
          organizers: _organizers,
        ),
      );
      if (success) {
        String ecotourId = state.value as String;
        widget.onEcotourEdited.call(ecotourId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      editEcotourControllerProvider(null).select((state) => state.value),
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(editEcotourControllerProvider(null));
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
                          key: EditEcotourScreen.titleKey,
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
                          key: EditEcotourScreen.descriptionKey,
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
                          key: EditEcotourScreen.dateKey,
                          initialDate: _date,
                          label: state.dateLabelText,
                          onDateSelected: _handleOnDateChanged,
                        ),
                        gapH20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomTimeOfDayPicker(
                              key: EditEcotourScreen.startTimeKey,
                              initialTimeOfDay: _startTime,
                              label: state.startTimeLabelText,
                              onTimeOfDaySelected: _handleOnStartTimeChanged,
                            ),
                            CustomTimeOfDayPicker(
                              key: EditEcotourScreen.endTimeKey,
                              initialTimeOfDay: _startTime,
                              label: state.endTimeLabelText,
                              onTimeOfDaySelected: _handleOnEndTimeChanged,
                            ),
                          ],
                        ),
                        gapH16,
                        CustomDropdown(
                          key: EditEcotourScreen.meetupPointKey,
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
                  key: EditEcotourScreen.organizersKey,
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
