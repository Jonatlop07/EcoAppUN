import 'package:flutter/material.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    Key? key,
    required this.label,
    this.initialOptionIndex,
    required this.options,
    this.onSelected,
    this.trailing,
  }) : super(key: key);

  final String label;
  final int? initialOptionIndex;
  final List<String> options;
  final Function(String)? onSelected;
  final Widget? trailing;

  @override
  State<StatefulWidget> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String selectedOption = '';

  @override
  void initState() {
    if (widget.options.isNotEmpty) {
      if (widget.initialOptionIndex != null) {
        setState(() {
          selectedOption = widget.options[widget.initialOptionIndex!];
        });
      } else {
        setState(() {
          selectedOption = widget.options.first;
        });
      }
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
    return Padding(
      padding: insetsAll8,
      child: Column(
        children: [
          Text(
            widget.label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          gapH8,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton(
                value: selectedOption,
                items: widget.options.map((String option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: handleOnChange,
              ),
              widget.trailing ?? Column()
            ],
          ),
        ],
      ),
    );
  }
}
