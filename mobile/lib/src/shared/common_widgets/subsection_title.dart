import 'package:flutter/material.dart';

class SubsectionTitle extends StatelessWidget {
  const SubsectionTitle({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}
