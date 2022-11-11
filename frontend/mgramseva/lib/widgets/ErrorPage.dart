import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'BaseAppBar.dart';
import 'BottonButtonBar.dart';
import 'HomeBack.dart';

class ErrorPage extends StatelessWidget {
  final label;

  ErrorPage(this.label);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        CommonMethods.home();
        return false;
      },
      child: Scaffold(
          appBar: BaseAppBar(
            Text(ApplicationLocalizations.of(context).translate(i18.common.MGRAM_SEVA)),
            AppBar(),
            <Widget>[Icon(Icons.more_vert)],
          ),
          body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeBack(callback: CommonMethods.home),
                    Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                padding: EdgeInsets.all(30),
                                decoration: new BoxDecoration(
                                    color: Colors.red[900]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    new Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          ApplicationLocalizations.of(context)
                                              .translate(label),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                          )),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Icon(
                                      Icons.warning_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ))
                  ])
          ),
        bottomNavigationBar: BottomButtonBar(
    ApplicationLocalizations.of(context).translate(i18.common.BACK_HOME),
          CommonMethods.home,
        ),),
    );
  }
}
