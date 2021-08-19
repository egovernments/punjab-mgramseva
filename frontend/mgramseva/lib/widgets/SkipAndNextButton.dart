import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class SkipAndNext extends StatelessWidget {
  final VoidCallback skip;
  final VoidCallback next;
  SkipAndNext(this.skip, this.next);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: constraints.maxWidth > 760
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: new ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 0)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0))),
                            ),
                            child: new Text(ApplicationLocalizations.of(context).translate('Skip'),
                            ),
                            onPressed: skip,
                          )),
                      Expanded(
                          child: new ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 0)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0))),
                            ),
                            child: new Text(ApplicationLocalizations.of(context).translate('Next'),
                            ),
                            onPressed: next,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}
