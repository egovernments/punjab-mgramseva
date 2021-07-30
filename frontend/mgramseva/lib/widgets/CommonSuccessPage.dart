import 'package:flutter/material.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/widgets/Back.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/SuccessPage.dart';

class CommonSuccess extends StatelessWidget {
  final String label;
  final String subtext;
  final String backtobutton;
  final Widget Function() navigatepage;
  CommonSuccess(this.label, this.subtext, this.backtobutton, this.navigatepage);

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
                          SuccessPage(label),
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 20, bottom: 20, top: 20),
                                child: Text(
                                    subtext,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                              )),
                          SizedBox(height: 20,),
                          FractionallySizedBox(
                              widthFactor: 0.90,
                              child: new ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(15),
                                ),
                                child: new Text(backtobutton,
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500)),
                                onPressed: () => Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            navigatepage())),
                              )),
                          SizedBox(height: 20,),
                        ],
                      )
                  )]
            )
        )
    );
  }
}