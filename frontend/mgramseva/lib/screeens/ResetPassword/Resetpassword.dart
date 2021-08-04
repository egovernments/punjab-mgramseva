import 'package:flutter/material.dart';
import 'package:mgramseva/providers/reset_password_provider.dart';
import 'package:mgramseva/widgets/Button.dart';
import 'package:mgramseva/widgets/DesktopView.dart';
import 'package:mgramseva/widgets/HeadingText.dart';
import 'package:mgramseva/widgets/MobileView.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/EnterOtp.dart';
import 'package:mgramseva/widgets/PasswordHint.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _ResetPasswordState();
  }
}

class _ResetPasswordState extends State<ResetPassword> {
  var password = "";
  var newpassword = new TextEditingController();
  var confirmpassword = new TextEditingController();
  var otpfiled_1 = new TextEditingController();
  var otpfiled_2 = new TextEditingController();
  var otpfiled_3 = new TextEditingController();
  var otpfiled_4 = new TextEditingController();

  var otpReference = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  saveInputpassword(context) async {
    setState(() {
      password = context.toString();
    });
  }

  saveInputandReset(context) async {
    var resetprovider = Provider.of<ResetPasswordProvider>(context, listen: false);
    resetprovider.resetpassword(context, otpfiled_1.text,otpfiled_2.text,otpfiled_3.text,otpfiled_4.text, newpassword.text.trim());
  }

  getresetcard() {
    return new Container(
        width: 500,
        padding: EdgeInsets.all(8),
        child: Card(
            child: (Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("mGramSeva",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            ),
            HeadingText("Reset Password ?"),
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                  child: Text("Enter the OTP sent to +91 ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                )),
            EnterOTP(otpfiled_1, otpfiled_2, otpfiled_3, otpfiled_4),
            Padding(
                padding: const EdgeInsets.only(
                    left: 25, top: 10, bottom: 10, right: 25),
                child: Text(
                  'Resend OTP',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )),
            BuildTextField(
              'Enter New Password',
              newpassword,
              isRequired: true,
              onChange: (value) => saveInputpassword(value),
            ),
            BuildTextField(
              'Confirm New  Password',
              confirmpassword,
              isRequired: true,
              onChange: (value) => saveInputpassword(value),
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
                            fontSize: 19, fontWeight: FontWeight.w500)),
                    onPressed: () => Button("CORE_COMMON_CONTINUE",
                        () => saveInputandReset(context))

                    // Navigator.push<bool>(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) =>
                    //             PasswordSuccess(
                    //                 "Password Reset Successfully"))
                    //                 ),
                    )),
            PasswordHint(password)
          ],
        ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(
        child: LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 760) {
        return MobileView(getresetcard());
      } else {
        return DesktopView(getresetcard());
      }
    })));
  }
}
