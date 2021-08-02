import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/SuccessPage.dart';

class CommonSuccess extends StatelessWidget {
  final  dynamic successHandler;

  CommonSuccess(this.successHandler);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              HomeBack(),
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
                        child: Text(successHandler.subtitle,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FractionallySizedBox(
                      widthFactor: 0.90,
                      child: new ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                        ),
                        child: new Text(successHandler.backButtonText,
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w500)),
                        onPressed: CommonMethods.home,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ))
            ])));
  }
}
