import 'package:flutter/material.dart';

import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/widgets/SkipAndNextButton.dart';
import 'package:mgramseva/widgets/SkipButton.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowcaseWidget extends StatelessWidget {
  final Widget child;
  final String description;
  final GlobalKey globalKey;
  final Widget button;
  /*final VoidCallback? skip;
  final VoidCallback? next;*/

  const CustomShowcaseWidget(this.globalKey, this.description, this.child, this.button);

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      key: globalKey,
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      overlayOpacity: 0.75,
      shapeBorder: RoundedRectangleBorder(),
      contentPadding: EdgeInsets.all(0),
      disableAnimation: true,
      overlayPadding: EdgeInsets.all(12),
      container: Container(
          padding: EdgeInsets.all(5.0),
          width: 400,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black12,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(4),),
          child: Column(
            children: <Widget>[
              Text(
                description,
                style: TextStyle(color: Colors.black,
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 10,),
                  Container(
                  child: button)
            ],
          )),
      child: child,
    );
  }
}
