import 'package:flutter/material.dart';
import 'package:mobile/src/shared/common_widgets/custom_text.dart';
import 'package:mobile/src/shared/common_widgets/secondary_icon_button.dart';
import 'package:mobile/src/shared/constants/app.colors.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';

import '../time/datetime.format.dart';

class CustomTimeOfDayPicker extends StatefulWidget {
  const CustomTimeOfDayPicker({
    Key? key,
    required this.label,
    this.initialTimeOfDay,
    this.onTimeOfDaySelected,
  }) : super(key: key);

  final TimeOfDay? initialTimeOfDay;
  final Function(TimeOfDay)? onTimeOfDaySelected;

  final String label;

  @override
  State<StatefulWidget> createState() => _MyTimeOfDayPickerState();
}

class _MyTimeOfDayPickerState extends State<CustomTimeOfDayPicker> {
  late TimeOfDay _selectedTimeOfDay;

  @override
  void didChangeDependencies() {
    if (widget.initialTimeOfDay != null) {
      _selectedTimeOfDay = widget.initialTimeOfDay!;
    } else {
      _selectedTimeOfDay = TimeOfDay.now();
    }
    super.didChangeDependencies();
  }

  Future<void> _selectTimeOfDay(BuildContext context) async {
    final TimeOfDay? pickedTimeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTimeOfDay,
    );
    if (pickedTimeOfDay != null && pickedTimeOfDay != _selectedTimeOfDay) {
      setState(() {
        _selectedTimeOfDay = pickedTimeOfDay;
      });
      if (widget.onTimeOfDaySelected != null) {
        widget.onTimeOfDaySelected!.call(pickedTimeOfDay);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: widget.label,
          textAlign: TextAlign.center,
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.darkestGreen,
                fontWeight: FontWeight.w400,
              ),
        ),
        gapH4,
        SecondaryIconButton(
          text: DateTimeFormat.tohhmm(_selectedTimeOfDay),
          icon: const Icon(Icons.timer_outlined),
          onPressed: () => _selectTimeOfDay(context),
        ),
      ],
    );
  }
}
