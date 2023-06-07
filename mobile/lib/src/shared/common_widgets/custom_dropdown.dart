import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    Key? key,
    required this.options,
    this.onSelected,
  }) : super(key: key);

  final List<String> options;
  final Function(String)? onSelected;

  @override
  State<StatefulWidget> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String selectedOption = '';

  @override
  void initState() {
    if (widget.options.isNotEmpty) {
      setState(() {
        selectedOption = widget.options.first;
      });
    }
    super.initState();
  }

  void handleOnChange(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedOption = newValue;
      });
      if (widget.onSelected != null) {
        widget.onSelected!.call(newValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedOption,
      items: widget.options.map((String option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: handleOnChange,
    );
  }
}
