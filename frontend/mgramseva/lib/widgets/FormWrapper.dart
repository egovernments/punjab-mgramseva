import 'package:flutter/material.dart';

class FormWrapper extends StatelessWidget {
  final Widget widget;
  FormWrapper(this.widget);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 25,
          right: MediaQuery.of(context).size.width / 25,
        ),
        child: widget);
  }
}
