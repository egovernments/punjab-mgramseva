import 'package:flutter/material.dart';
import 'package:mgramseva/app_config.dart';
import 'package:mgramseva/providers/authentication.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/services/user.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/widgets/Button.dart';
import 'package:mgramseva/widgets/DesktopView.dart';
import 'package:mgramseva/widgets/HeadingText.dart';
import 'package:mgramseva/widgets/MobileView.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/screeens/ForgotPassword/ForgotPassword.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  var mobileNumber = new TextEditingController();
  var userNamecontroller = new TextEditingController();
  var passwordcontroller = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  saveInput(context) async {
    print(context);
  }

  saveandLogin(context) async {
    if (formKey.currentState!.validate()) {
      var authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
      authProvider.validateLogin(context, userNamecontroller.text.trim(), passwordcontroller.text.trim());
    }
  }

  Widget getLoginCard() {
    return Card(
        child: Form(
            key: formKey,
            child: (Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("mGramSeva",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                ),
                HeadingText(ApplicationLocalizations.of(context)
                    .translate("CORE_COMMON_LOGIN")),
                // BuildTextField(
                //     context, 'Phone Number', mobileNumber, '', '+91-', saveInput),
                BuildTextField(context, 'CORE_LOGIN_USERNAME',
                    userNamecontroller, '', '', saveInput, true),
                BuildTextField(
                    context,
                    'CORE_LOGIN_PASSWORD',
                    passwordcontroller,
                    '',
                    '',
                    (value) => saveInput(value),
                    true),
                GestureDetector(
                  onTap: () => Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ForgotPassword())),
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25, top: 10, bottom: 10, right: 25),
                      child: new Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            ApplicationLocalizations.of(context)
                                .translate('CORE_COMMON_FORGOT_PASSWORD'),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ))),
                ),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Button(
                        "CORE_COMMON_CONTINUE", () => saveandLogin(context))),
                SizedBox(
                  height: 10,
                )
              ],
            ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 760) {
        return MobileView(getLoginCard());
      } else {
        return DesktopView(getLoginCard());
      }
    }));
  }
}
