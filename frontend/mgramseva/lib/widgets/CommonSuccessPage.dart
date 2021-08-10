import 'package:flutter/material.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/SuccessPage.dart';

class CommonSuccess extends StatelessWidget {
  final SuccessHandler successHandler;

  CommonSuccess(this.successHandler);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        CommonMethods.home();
        return false;
      },
      child: Scaffold(
          appBar: BaseAppBar(
            Text(i18.common.MGRAM_SEVA),
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
                    SuccessPage(successHandler.header),
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20, bottom: 20, top: 20),
                          child: Text(
                              ApplicationLocalizations.of(context)
                                  .translate(successHandler.subtitle),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400)),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    BottomButtonBar(
                      successHandler.backButtonText,
                      CommonMethods.home,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ))
              ]))),
    );
  }
}
