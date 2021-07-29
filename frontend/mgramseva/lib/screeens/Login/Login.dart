import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/providers/authentication.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/validators/Validators.dart';
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
  var autoValidation = false;

  @override
  void initState() {
    super.initState();
  }

  saveandLogin(context) async {
    var authProvider =
    Provider.of<AuthenticationProvider>(context, listen: false);

    if (formKey.currentState!.validate()) {
      authProvider.validateLogin(context, userNamecontroller.text.trim(),
          passwordcontroller.text.trim());
    }else{
      autoValidation = true;
      authProvider.callNotifyer();
    }
  }

  Widget getLoginCard() {
    return Card(
        child: Form(
            key: formKey,
            autovalidateMode: autoValidation ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: (Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("mGramSeva",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                ),
                HeadingText(ApplicationLocalizations.of(context)
                    .translate(i18.login.LOGIN_LABEL)),
                BuildTextField(
                  i18.common.PHONE_NUMBER,
                  userNamecontroller,
                  prefixText: '+91',
                  isRequired: true,
                  inputFormatter: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                  maxLength: 10,
                  validator: Validators.mobileNumberValidator,
                  textInputType: TextInputType.phone,
                ),
                BuildTextField(
                  i18.login.LOGIN_PASSWORD,
                  passwordcontroller,
                  isRequired: true,
                  obscureText: true,
                  maxLines: 1,
                  inputFormatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@. ]"))],
                ),
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
                                .translate(i18.login.FORGOT_PASSWORD),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ))),
                ),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Button(
                        i18.common.CONTINUE, () => saveandLogin(context))),
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
