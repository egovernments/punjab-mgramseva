import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardFocusWatcher extends StatelessWidget {
  final Widget child;
  const KeyboardFocusWatcher({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: child,
    );
  }
}
