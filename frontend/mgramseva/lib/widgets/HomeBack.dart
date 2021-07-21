import 'package:flutter/material.dart';

class HomeBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: TextButton(
          child: Row(
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
          onPressed: () {
            return Navigator.pop(context);
          },
        ));
  }
}
