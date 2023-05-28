import 'package:flutter/material.dart';

class SubsectionText extends StatelessWidget {
  const SubsectionText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal),
      textAlign: TextAlign.center,
    );
  }
}
