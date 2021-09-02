import 'package:flutter/material.dart';
import 'package:mgramseva/widgets/Back.dart';
import 'package:mgramseva/widgets/BackgroundContainer.dart';
import 'package:mgramseva/widgets/footerBanner.dart';

class MobileView extends StatelessWidget {
  final Widget widget;
  MobileView(this.widget);

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(new Container(
        child: new Stack(
            // // fit: StackFit.expand,
            // clipBehavior: Clip.antiAlias,
            children: <Widget>[
              Back(),
              (new Positioned(
                  bottom: 30.0,
                  child: new Container(
                      margin: EdgeInsets.only(bottom: 5),
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height + 20,
                      padding: EdgeInsets.all(8),
                      child: widget))),
              (new Positioned(
                  bottom: 0.0,
                  left: MediaQuery.of(context).size.width / 4,
                  child: FooterBanner()))
            ])));
  }
}
