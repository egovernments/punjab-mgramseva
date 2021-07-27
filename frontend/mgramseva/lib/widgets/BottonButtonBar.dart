import 'package:flutter/material.dart';

class BottomButtonBar extends StatelessWidget {
  final String label;
  final VoidCallback callBack;
  BottomButtonBar(this.label, this.callBack);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 760) {
            return Align(
              alignment: Alignment.centerRight,
              child: Container(
                  margin: EdgeInsets.only(
                      right: 20),
                  width: 300,
                  child:  ElevatedButton(
                    child:  Text(label),
                    onPressed: callBack,
                  )),
            );
          } else {
            return Container(
              width: constraints.maxWidth,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: ElevatedButton(
                child:  Text(this.label,),
                onPressed:  callBack,
              ),
            );
          }
        }));
  }
}
