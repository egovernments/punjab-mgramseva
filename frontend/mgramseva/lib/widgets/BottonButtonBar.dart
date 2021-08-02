import 'package:flutter/material.dart';
import 'package:mgramseva/utils/color_codes.dart';
import 'package:mgramseva/utils/common_styles.dart';

class BottomButtonBar extends StatelessWidget {
  final String label;
  final VoidCallback callBack;
  BottomButtonBar(this.label, this.callBack);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        child: Card(
          elevation: 18.0,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > 760) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        decoration: CommonStyles.buttonBottomDecoration,
                        margin: EdgeInsets.only(right: 20),
                        width: 300,
                        child: _buildButton()),
                  );
                } else {
                  return Container(
                      decoration: CommonStyles.buttonBottomDecoration,
                      width: constraints.maxWidth,
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: _buildButton());
                }
              })),
        ));
  }

  Widget _buildButton() {
    return ElevatedButton(
      child: Text(
        this.label,
      ),
      onPressed: callBack,
    );
  }
}
