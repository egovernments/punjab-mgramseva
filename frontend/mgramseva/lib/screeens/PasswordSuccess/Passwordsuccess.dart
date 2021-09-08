import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/widgets/DesktopView.dart';
import 'package:mgramseva/widgets/Logo.dart';
import 'package:mgramseva/widgets/MobileView.dart';
import 'package:mgramseva/widgets/SuccessPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordSuccess extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _PasswordSuccessState();
  }
}

class _PasswordSuccessState extends State<PasswordSuccess> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 760) {
        return MobileView(getLoginCard());
      } else {
        return DesktopView(getLoginCard());
      }
    }));
  }

  Widget getLoginCard() {
    return Card(
        child: (Column(
      children: [
        Logo(),
        SuccessPage(
          i18.password.CHANGE_PASSWORD_SUCCESS,
        ),
        Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(left: 20, bottom: 20, top: 20),
              child: Text(
                  ApplicationLocalizations.of(context)
                      .translate(i18.password.CHANGE_PASSWORD_SUCCESS_SUBTEXT),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            )),
        SizedBox(
          height: 10,
        ),
        FractionallySizedBox(
            widthFactor: 0.90,
            child: new ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15),
              ),
              child: new Text(
                  ApplicationLocalizations.of(context)
                      .translate(i18.common.CONTINUE_TO_LOGIN),
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500)),
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.LOGIN, (Route<dynamic> route) => false),
            )),
        SizedBox(
          height: 10,
        ),
      ],
    )));
  }
}
