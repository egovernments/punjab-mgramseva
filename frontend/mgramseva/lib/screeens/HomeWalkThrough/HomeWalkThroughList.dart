import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/global_variables.dart';

var json = Constants.HOME_ITEMS.map((e) => {
  "name": e.walkThroughMsg,
  "widget": Card(
    elevation: 0,
      margin:
      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(e.iconData, size: 35),
          Container(
            margin: EdgeInsets.all(10),
            child: Center(
                child: new Text(
                  ApplicationLocalizations.of(navigatorKey.currentContext!)
                      .translate(e.label),
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                )),
          )
        ],
      )),
},).toList();

class HomeWalkThrough {
  final List<HomeWalkWidgets> homeWalkThrough = json
      .map((e) => HomeWalkWidgets(
      name: e['name'] as String, widget: e['widget'] as Widget))
      .toList();
}

class HomeWalkWidgets {
  final String name;
  final Widget widget;
  bool isActive = false;
  GlobalKey? key;
  HomeWalkWidgets({required this.name, required this.widget});
}
