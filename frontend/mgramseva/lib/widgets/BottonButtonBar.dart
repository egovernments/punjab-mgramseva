import 'package:flutter/material.dart';

class BottomButtonBar extends StatelessWidget {
  final String label;
  final Function buttonfunction;
  BottomButtonBar(this.label, this.buttonfunction);
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
                    child: new ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(18),
                      ),
                      child: new Text(label,
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w500)),
                      onPressed: () => buttonfunction(),
                    ));
              } else {
                return Container(
                    child: new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(18),
                  ),
                  child: new Text(this.label,
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500)),
                  onPressed: () => buttonfunction(),
                ));
              }
            })));
  }
}
