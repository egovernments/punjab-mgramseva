import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_styles.dart';

class SideButton extends StatelessWidget {
  final String label;
  final Function widgetfunction;
  SideButton(this.label, this.widgetfunction);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return new FractionallySizedBox(
          widthFactor: constraints.maxWidth > 760 ? 0.3 : 1,
          child: Container(
            decoration: CommonStyles.buttonBottomDecoration,
            child: new ElevatedButton(
                child: new Text(
                    ApplicationLocalizations.of(context).translate(label),
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
                ),
                onPressed: () {
                  widgetfunction();
                },
            ),
          ));
    });
  }
}
