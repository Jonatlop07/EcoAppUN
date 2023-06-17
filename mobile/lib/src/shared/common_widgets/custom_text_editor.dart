import 'package:flutter/material.dart';
import 'package:zefyrka/zefyrka.dart';

import '../constants/app.sizes.dart';

class CustomTextEditor extends StatefulWidget {
  const CustomTextEditor({
    Key? key,
    required this.controller,
    this.initialDocument,
    this.focusNode,
  }) : super(key: key);

  final ZefyrController controller;
  final String? initialDocument;
  final FocusNode? focusNode;

  @override
  State<StatefulWidget> createState() => _CustomTextEditorState();
}

class _CustomTextEditorState extends State<CustomTextEditor> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: insetsAll12,
        child: Column(
          children: [
            ZefyrToolbar.basic(
              controller: widget.controller,
            ),
            SizedBox(
              width: double.infinity,
              child: ZefyrEditor(
                controller: widget.controller,
                focusNode: widget.focusNode,
                readOnly: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
