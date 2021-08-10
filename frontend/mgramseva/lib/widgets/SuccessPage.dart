import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class SuccessPage extends StatelessWidget {
  final label;
  SuccessPage(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(30),
        decoration: new BoxDecoration(color: Colors.green[900]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new Align(
              alignment: Alignment.center,
              child: Text(ApplicationLocalizations.of(context).translate(label),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 32,
            )
          ],
        ));
  }
}
