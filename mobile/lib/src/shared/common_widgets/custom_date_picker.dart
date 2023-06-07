import 'package:flutter/material.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({Key? key, this.onDateSelected, this.label}) : super(key: key);

  final Function(DateTime)? onDateSelected;

  final String? label;

  @override
  State<StatefulWidget> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<CustomDatePicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
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
      children: [
        Text('${widget.label}: ${selectedDate.toString()}'),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text('Seleccione la fecha'.hardcoded),
        ),
      ],
    );
  }
}
