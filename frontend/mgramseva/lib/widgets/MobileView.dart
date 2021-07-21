import 'package:flutter/material.dart';
import 'package:mgramseva/widgets/Back.dart';
import 'package:mgramseva/widgets/BackgroundContainer.dart';

class MobileView extends StatelessWidget {
  final Widget widget;
  MobileView(this.widget);

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(new Container(
        padding: const EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child: new Stack(
            // // fit: StackFit.expand,
            // clipBehavior: Clip.antiAlias,
            children: <Widget>[
              Back(),
              (new Positioned(
                  bottom: 30.0,
                  child: new Container(
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height + 20,
                      padding: EdgeInsets.all(8),
                      child: widget)))
            ])));
  }
}
