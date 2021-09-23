import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

import 'ShortButton.dart';

class ButtonGroup extends StatelessWidget {
  final String label;
  final VoidCallback callBack;
  final VoidCallback callBackIcon;
  ButtonGroup(
    this.label,
    this.callBackIcon,
    this.callBack,
  );
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
                          child: OutlinedButton.icon(
                        onPressed: callBackIcon,
                        style: ButtonStyle(
                          alignment: Alignment.center,
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 0.0)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            side: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor),
                          )),
                        ),
                        icon: (Image.asset('assets/png/whats_app.png', fit: BoxFit.fitHeight,)),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                              ApplicationLocalizations.of(context)
                                  .translate(i18.common.SHARE_BILL),
                              style: Theme.of(context).textTheme.subtitle2)),
                      )),
                      Expanded(child: ShortButton(label, callBack))
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
