import 'package:flutter/material.dart';

class BottomButtonBar extends StatelessWidget {
  final String label;
  final VoidCallback callBack;
  BottomButtonBar(this.label, this.callBack);
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 18.0,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 760) {
                return Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width - 300,
                        right: 20),
                    child:  ElevatedButton(
                      child:  Text(label),
                      onPressed: callBack,
                    ));
              } else {
                return ElevatedButton(
                  child:  Text(this.label,),
                  onPressed:  callBack,
                );
              }
            })));
  }
}
