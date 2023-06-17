import 'package:flutter/material.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';
import 'package:zefyrka/zefyrka.dart';

class EditorContentPresenter extends StatelessWidget {
  const EditorContentPresenter({Key? key, required this.controller}) : super(key: key);

  final ZefyrController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: ZefyrEditor(
          controller: controller,
          autofocus: true,
          expands: false,
          readOnly: true,
          showCursor: false,
          padding: insetsH8,
        ),
      ),
    );
  }
}
