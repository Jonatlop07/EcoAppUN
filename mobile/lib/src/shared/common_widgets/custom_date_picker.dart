import 'package:flutter/material.dart';
import 'package:mobile/src/shared/common_widgets/custom_text.dart';
import 'package:mobile/src/shared/common_widgets/secondary_icon_button.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';

import '../constants/app.colors.dart';
import '../time/datetime.format.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    Key? key,
    required this.label,
    this.initialDate,
    this.onDateSelected,
  }) : super(key: key);

  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;

  final String label;

  @override
  State<StatefulWidget> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<CustomDatePicker> {
  late DateTime selectedDate;

  @override
  void didChangeDependencies() {
    if (widget.initialDate != null) {
      selectedDate = widget.initialDate!;
    } else {
      selectedDate = DateTime.now();
    }
    super.didChangeDependencies();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      if (widget.onDateSelected != null) {
        widget.onDateSelected!.call(pickedDate);
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
          text: DateTimeFormat.toYYYYMMDD(selectedDate),
          icon: const Icon(Icons.calendar_month_outlined),
          onPressed: () => _selectDate(context),
        ),
      ],
    );
  }
}
