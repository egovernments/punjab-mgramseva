import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GpwscCard extends StatelessWidget {
  final List<Widget> children;
  const GpwscCard({
    Key? key,required this.children
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        margin: EdgeInsets.only(bottom: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children),
      );
    });
  }
}