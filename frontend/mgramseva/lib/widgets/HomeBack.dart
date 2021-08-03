import 'package:flutter/material.dart';

class HomeBack extends StatelessWidget {

  final Widget? widget;
  final VoidCallback? callback;

  const HomeBack({Key? key, this.widget, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: widget == null ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
          children : [
            TextButton(
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(
                  Icons.arrow_left,
                  color: Colors.black,
                ),
                Text(
                  "Back",
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
            onPressed: callback ?? () =>  Navigator.pop(context)
          ),
            if(widget != null)
              widget!
          ]
        ));
  }
}
