import 'package:flutter/material.dart';
import 'package:mgramseva/widgets/Back.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/PasswordHint.dart';
import 'package:mgramseva/screeens/Passwordsuccess.dart';

class UpdatePassword extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _UpdatePasswordState();
  }
}

class _UpdatePasswordState extends State<UpdatePassword> {
  var mobileNumber = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  saveInput(context) async {
    print(context);
  }

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
                            child: Text("mGramSeva",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w700)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("update Password ? ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700)),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 20, bottom: 20, top: 20),
                                child: Text(
                                    "Dear Harpreet, you have been invited to mGramSeva application of",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                              )),
                          BuildTextField('Enter New Password', mobileNumber),
                          BuildTextField(
                            'Confirm New  Password',
                            mobileNumber,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FractionallySizedBox(
                              widthFactor: 0.90,
                              child: new ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(15),
                                  ),
                                  child: new Text('Continue',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w500)),
                                  onPressed: () =>
                                      Navigator.of(context).pushReplacement(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return new PasswordSuccess(
                                            " Password Updated Successfully");
                                      })))),
                          PasswordHint('')
                        ],
                      ))))))
            ])));
  }
}
