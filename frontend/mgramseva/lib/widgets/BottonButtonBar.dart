import 'package:flutter/material.dart';
import 'package:mgramseva/utils/color_codes.dart';

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
                  decoration: decoration,
                  margin: EdgeInsets.only(
                      right: 20),
                  width: 300,
                  child:  _buildButton()),
            );
          } else {
            return Container(
              decoration: decoration,
              width: constraints.maxWidth,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: _buildButton()
            );
          }
        }));
  }

  Widget _buildButton() {
    return ElevatedButton(
      child:  Text(this.label,),
      onPressed:  callBack,
    );
  }

  BoxDecoration get decoration => BoxDecoration(
      border: Border(bottom: BorderSide(color: ColorCodes.BUTTON_BOTTOM_COLOR, width: 2))
  );
}
