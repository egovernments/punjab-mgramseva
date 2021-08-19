import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/color_codes.dart';
import 'package:mgramseva/utils/common_styles.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback callBack;
  SkipButton(this.callBack);

  @override
  Widget build(BuildContext context) {
    return new Align (
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 0)),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0))),
          ),
          child: new Text('Skip',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)
          ),
          onPressed: callBack,
        ));
  }
}
