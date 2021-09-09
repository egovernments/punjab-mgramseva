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
      return new  Container(
        height: 40,
        width: constraints.maxWidth > 760 ? constraints.maxWidth / 4 : constraints.maxWidth,
            decoration: CommonStyles.buttonBottomDecoration,
            child: new ElevatedButton(
               style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 30),
                 padding: EdgeInsets.all(15),
               ),
              child: new Text(
                  ApplicationLocalizations.of(context).translate(label),
                   style:
                   Theme.of(context).textTheme.subtitle1
            ),
              onPressed: callBack
            ),
          );
    });
  }
}
