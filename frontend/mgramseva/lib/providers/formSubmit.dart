import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class FormSubmit extends StatefulWidget {
  final String htmlCode;

  FormSubmit(this.htmlCode);
  State<StatefulWidget> createState() {
    return _FormSubmitState();
  }
}

class _FormSubmitState extends State<FormSubmit> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: WebViewX(
            height: 750,
            width: 700,
            initialContent: widget.htmlCode,
            initialSourceType: SourceType.html,
          ),
        ),
      );
}
