

import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  final VoidCallback? callBack;
  Help({this.callBack});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: callBack, icon: Icon(Icons.help_outline_outlined), iconSize: 30);
  }
}
