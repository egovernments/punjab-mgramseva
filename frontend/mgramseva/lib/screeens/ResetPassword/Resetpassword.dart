import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/repository/forgot_password_repo.dart';
import 'package:mgramseva/repository/reset_password_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/validators/Validators.dart';
import 'package:mgramseva/widgets/BackgroundContainer.dart';
import 'package:mgramseva/widgets/Logo.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/PasswordHint.dart';
import 'package:mgramseva/widgets/footerBanner.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  String? id;

  ResetPassword({String? id});

  State<StatefulWidget> createState() {
    return _ResetPasswordState();
  }
}

class _ResetPasswordState extends State<ResetPassword> {
  var newPassword = new TextEditingController();
  var confirmPassword = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  TextEditingController _pinEditingController = TextEditingController();
  var autoValidate = false;
  var password = "";

  @override
  void initState() {
    afterBuildContext();
    super.initState();
  }

  saveInput(context) async {
    setState(() {
      password = context;
    });
  }

  afterBuildContext() async {
    // sendOtp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundContainer(new Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: autoValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: new Column(children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: MediaQuery.of(context).size.width > 720
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 4),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                  ),
                                  iconSize: 25,
                                  color: Colors.white,
                                  splashColor: Colors.purple,
                                  onPressed: () =>
                                      Navigator.of(context, rootNavigator: true)
                                          .maybePop()))
                          : IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                              ),
                              iconSize: 25,
                              color: Colors.white,
                              splashColor: Colors.purple,
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .maybePop())),
                  Container(
                      padding: EdgeInsets.all(8),
                      child: Card(
                          child: Container(
                              width: MediaQuery.of(context).size.width > 720
                                  ? MediaQuery.of(context).size.width / 3
                                  : MediaQuery.of(context).size.width,
                              child: (Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Logo(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        '${ApplicationLocalizations.of(context).translate(i18.password.CORE_COMMON_RESET_PASSWORD)}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  _buildOtpView(),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        '${ApplicationLocalizations.of(context).translate(i18.password.UPDATE_PASSWORD_TO_CONTINUE)}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                  ),
                                  BuildTextField(
                                    i18.password.CORE_COMMON_NEW_PASSWORD,
                                    newPassword,
                                    isRequired: true,
                                    validator: (val) =>
                                        Validators.passwordComparision(
                                            val,
                                            i18.password
                                                .CORE_COMMON_NEW_PASSWORD),
                                    onChange: saveInput,
                                  ),
                                  BuildTextField(
                                    i18.password
                                        .CORE_COMMON_CONFIRM_NEW_PASSWORD,
                                    confirmPassword,
                                    isRequired: true,
                                    validator: (val) =>
                                        Validators.passwordComparision(
                                            val,
                                            i18.password
                                                .CORE_COMMON_CONFIRM_NEW_PASSWORD,
                                            confirmPassword.text),
                                    onChange: saveInput,
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
                                          child: new Text(
                                              ApplicationLocalizations.of(
                                                      context)
                                                  .translate(i18.password
                                                      .CHANGE_PASSWORD),
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w500)),
                                          onPressed: updatePassword)),
                                  PasswordHint(password)
                                ],
                              ))))),
                  FooterBanner()
                ]),
              ),
            ))));
  }

  Widget _buildOtpView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Wrap(
        direction: Axis.vertical,
        spacing: 5,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          RichText(
              text: TextSpan(
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color.fromRGBO(80, 90, 95, 1)),
                  children: [
                TextSpan(
                    text:
                        '${ApplicationLocalizations.of(context).translate(i18.password.ENTER_OTP_SENT_TO)} '),
                TextSpan(
                    text: '+ 91 -${widget.id}',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(11, 12, 12, 1)))
              ])),
          Container(
            width: 300,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: PinInputTextField(
              pinLength: 6,
              decoration: BoxLooseDecoration(
                  strokeColorBuilder: PinListenColorBuilder(
                      Theme.of(context).primaryColor, Colors.grey),
                  radius: Radius.zero),
              controller: _pinEditingController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.phone,
              enableInteractiveSelection: false,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$'))
              ],
            ),
          ),
          TextButton(
              onPressed: sendOtp,
              child: Text(ApplicationLocalizations.of(context)
                  .translate(i18.password.RESENT_OTP)))
        ],
      ),
    );
  }

  void updatePassword() async {
    var commonProvider = Provider.of<LanguageProvider>(context, listen: false);

    if (formKey.currentState!.validate()) {
      var body = {
        "otpReference": _pinEditingController.text.trim(),
        "userName": widget.id,
        "newPassword": newPassword.text.trim(),
        "tenantId": commonProvider.stateInfo!.code,
        "type": 'Employee'
      };

      try {
        Loaders.showLoadingDialog(context);

        var resetResponse =
            await ResetPasswordRepository().forgotPassword(body, context);
        Navigator.pop(context);
        if (resetResponse != null) {
          Navigator.pushReplacementNamed(context, Routes.SUCCESS_VIEW,
              arguments: SuccessHandler(
                i18.password.CHANGE_PASSWORD_SUCCESS,
                i18.password.CHANGE_PASSWORD_SUCCESS_SUBTEXT,
                i18.common.BACK_HOME,
                Routes.SUCCESS_VIEW,
              ));
        }
      } catch (e, s) {
        Navigator.pop(context);
        ErrorHandler().allExceptionsHandler(context, e, s);
      }
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  sendOtp() async {
    var commonProvider = Provider.of<LanguageProvider>(context, listen: false);
    var body = {
      "otp": {
        "mobileNumber": widget.id,
        "tenantId": commonProvider.stateInfo!.code,
        "type": "passwordreset",
        "userType": 'Employee'
      }
    };

    try {
      var otpResponse =
          await ForgotPasswordRepository().forgotPassword(body, context);
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
  }
}
