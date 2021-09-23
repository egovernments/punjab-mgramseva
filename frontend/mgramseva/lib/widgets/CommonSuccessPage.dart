import 'package:flutter/material.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/SuccessPage.dart';

import 'DrawerWrapper.dart';
import 'SideBar.dart';
import 'footer.dart';

class CommonSuccess extends StatelessWidget {
  final SuccessHandler successHandler;
  final VoidCallback? callBack;
  final VoidCallback? callBackwatsapp;
  final VoidCallback? callBackdownload;
  final bool? backButton;
  final bool isWithoutLogin;

  CommonSuccess(this.successHandler,
      {this.callBack,
      this.callBackwatsapp,
      this.callBackdownload,
      this.backButton, this.isWithoutLogin = false});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        CommonMethods.home();
        return false;
      },
      child: Scaffold(
          appBar: isWithoutLogin ? AppBar(
            title: Text('mGramSeva'),
            automaticallyImplyLeading: false,
          ) : BaseAppBar(
            Text(i18.common.MGRAM_SEVA),
            AppBar(),
            <Widget>[Icon(Icons.more_vert)],
          ),
          drawer:  isWithoutLogin ? null : DrawerWrapper(Drawer(child: SideBar())),
          body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                backButton == true
                    ? HomeBack(callback: CommonMethods.home)
                    : Text(''),
                Card(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SuccessPage(successHandler.header,
                            subTextHeader:  successHandler.subHeaderFun != null ? successHandler.subHeaderFun!() : successHandler.subHeader,
                            subText: successHandler.subTextFun != null ? successHandler.subTextFun!() : successHandler.subHeaderText),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 10, bottom: 20, top: 20, right: 10),
                              child: Text(
                                ApplicationLocalizations.of(context)
                                    .translate(successHandler.subtitleFun != null ? successHandler.subtitleFun!() : successHandler.subtitle),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.start,
                              ),
                            )),
                        Visibility(
                          visible: successHandler.downloadLink == null &&
                              successHandler.whatsAppShare == null &&
                              successHandler.downloadLinkLabel == null,
                          child: SizedBox(
                            height: 20,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: successHandler.downloadLink != null,
                              child: TextButton.icon(
                                onPressed: callBackdownload,
                                icon: Icon(Icons.download_sharp),
                                label: Text(
                                    ApplicationLocalizations.of(context)
                                        .translate(successHandler
                                                    .downloadLinkLabel !=
                                                null
                                            ? successHandler.downloadLinkLabel!
                                            : ''),
                                    style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor)),
                              ),
                            ),
                            Visibility(
                              visible: successHandler.whatsAppShare != null,
                              child: TextButton.icon(
                                onPressed: callBackwatsapp,
                                icon: (Image.asset('assets/png/whats_app.png')),
                                label: Text(
                                      ApplicationLocalizations.of(context)
                                          .translate(i18.common.SHARE_BILL),
                                  style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),),

                              ),
                            )
                          ],
                        ),
                        Visibility(
                          visible: !isWithoutLogin,
                          child: BottomButtonBar(
                          successHandler.backButtonText,
                            callBack != null ? callBack : CommonMethods.home,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Footer(),
                      ],
                    ))
              ]))),
    );
  }
}
