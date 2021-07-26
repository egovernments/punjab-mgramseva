import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/services/user.dart';
import 'package:mgramseva/widgets/Button.dart';
import 'package:mgramseva/widgets/DesktopView.dart';
import 'package:mgramseva/widgets/Logo.dart';
import 'package:mgramseva/widgets/MobileView.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/screeens/ResetPassword/Resetpassword.dart';

class ForgotPassword extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var mobileNumber = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  saveInput(context) async {
    print(context);
  }

  saveInputandcall(context) async {
    var data = {
      "otp": {
        "mobileNumber": "9686151676",
        "tenantId": "pb",
        "type": "passwordreset",
        "userType": "EMPLOYEE"
      }
    };

    otpforresetpassword(data, context);
  }

  getForgotPasswordCard() {
    return new Container(
        height: 380,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8),
        child: Card(
            child: (Column(
          children: [
            Logo(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Forgot Password ? ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 20, top: 20),
                  child: Text(
                      "Please Enter your Phone Number to Reset password.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                )),
            BuildTextField(
              'Phone Number',
              mobileNumber,
              isRequired: true,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: EdgeInsets.all(15),
                child: Button(
                    "CORE_COMMON_CONTINUE", () => saveInputandcall(context))),
          ],
        ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 760) {
        return MobileView(getForgotPasswordCard());
      } else {
        return DesktopView(getForgotPasswordCard());
      }
    }));
  }
}
