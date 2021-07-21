import 'package:flutter/material.dart';

class DrawerWrapper extends StatelessWidget {
  final widget;
  DrawerWrapper(this.widget);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          width: constraints.maxWidth < 760
              ? MediaQuery.of(context).size.width * .7
              : MediaQuery.of(context).size.width / 4,
          margin: EdgeInsets.only(top: 60),
          child: widget);
    });
  }
}
