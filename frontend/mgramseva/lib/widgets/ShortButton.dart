import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_styles.dart';

class ShortButton extends StatelessWidget {
  final String label;
  final VoidCallback? callBack;
  ShortButton(this.label, this.callBack);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return new FractionallySizedBox(
          widthFactor: constraints.maxWidth > 760 ? 0.3 : 1,
          child: Container(
            decoration: CommonStyles.buttonBottomDecoration,
            child: new ElevatedButton(
              // style: ElevatedButton.styleFrom(
              //   minimumSize: Size(double.infinity, 30),
              //   padding: EdgeInsets.all(15),
              // ),
              child: new Text(
                  ApplicationLocalizations.of(context).translate(label),
                  // style:
                  //     TextStyle(fontSize: 19, fontWeight: FontWeight.w500)
            ),
              onPressed: callBack
            ),
          ));
    });
  }
}
