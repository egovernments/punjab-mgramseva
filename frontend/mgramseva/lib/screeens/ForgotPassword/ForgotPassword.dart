import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/services/user.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/validators/Validators.dart';
import 'package:mgramseva/widgets/Button.dart';
import 'package:mgramseva/widgets/DesktopView.dart';
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
  var autoValidation = false;

  saveInputandcall(context) async {

    if(formKey.currentState!.validate()) {
      var data = {
        "otp": {
          "mobileNumber": "9686151676",
          "tenantId": "pb",
          "type": "passwordreset",
          "userType": "EMPLOYEE"
        }
      };

      otpforresetpassword(data, context);
    }else{
      setState(() {
        autoValidation = true;
      });
    }
  }

  getForgotPasswordCard() {
    return new Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8),
        child: Card(
            child: (Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("mGramSeva",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            ),
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
            Form(
              key: formKey,
              autovalidateMode: autoValidation ? AutovalidateMode.always : AutovalidateMode.disabled,
              child: BuildTextField(
                'Phone Number',
                mobileNumber,
                prefixText: '+91',
                isRequired: true,
                inputFormatter: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                maxLength: 10,
                validator: Validators.mobileNumberValidator,
                textInputType: TextInputType.phone,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: EdgeInsets.all(15),
                child: Button(
                    i18.common.CONTINUE, () => saveInputandcall(context))),
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
