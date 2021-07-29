import 'package:flutter/material.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/widgets/Back.dart';
import 'package:mgramseva/widgets/SuccessPage.dart';

class EditProfileSuccess extends StatelessWidget {
  final String label;
  final String subtext;
  EditProfileSuccess(this.label, this.subtext);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              color: const Color(0xff0B4B66),
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.dstATop),
                image: NetworkImage(
                    "https://s3.ap-south-1.amazonaws.com/pb-egov-assets/pb.testing/Punjab-bg-QA.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: new Stack(children: <Widget>[
              Back(),
              (new Positioned(
                  bottom: 20.0,
                  child: new Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(8),
                      child: Card(
                          child: (Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(i18.common.MGRAM_SEVA,
                                    style: TextStyle(
                                        fontSize: 24, fontWeight: FontWeight.w700)),
                              ),
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
                              SizedBox(
                                height: 10,
                              ),
                              FractionallySizedBox(
                                  widthFactor: 0.90,
                                  child: new ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(15),
                                    ),
                                    child: new Text(i18.common.BACK_HOME,
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500)),
                                    onPressed: () => Navigator.push<bool>(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Home(0))),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ))))))
            ])));
  }
}