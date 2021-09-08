import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:mgramseva/model/mdms/tenants.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/model/user/user_details.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/repository/forgot_password_repo.dart';
import 'package:mgramseva/repository/reset_password_repo.dart';
import 'package:mgramseva/repository/tendants_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/utils/validators/Validators.dart';
import 'package:mgramseva/widgets/BackgroundContainer.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/Logo.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/PasswordHint.dart';
import 'package:mgramseva/widgets/footerBanner.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';

class UpdatePassword extends StatefulWidget {
  final UserDetails userDetails;

  const UpdatePassword({Key? key, required this.userDetails}) : super(key: key);
  State<StatefulWidget> createState() {
    return _UpdatePasswordState();
  }
}

class _UpdatePasswordState extends State<UpdatePassword> {
  late CountdownTimerController timerController;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  var newPassword = new TextEditingController();
  var confirmPassword = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isdisabled = true;
  List<Tenants>? tenantsList;
  TextEditingController _pinEditingController = TextEditingController();
  var autoValidate = false;
  var password = "";
  var pinLength = 6;

  @override
  void initState() {
    afterBuildContext();
    super.initState();
    timerController = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  @override
  void dispose() {
    timerController.dispose();
    super.dispose();
  }

  saveInput(context) async {
    setState(() {
      password = context;
    });
  }

  void onEnd() {
    setState(() {
      isdisabled = false;
    });
  }

  afterBuildContext() async {
    sendOtp();
    var tenants = await TenantRepo().fetchTenants(
        getTenantsMDMS(widget.userDetails.userRequest!.tenantId.toString()),
        widget.userDetails.accessToken);
    final r = widget.userDetails!.userRequest!.roles!
        .map((e) => e.tenantId)
        .toSet()
        .toList();
    var result = tenants.tenantsList!
        .where((element) => r.contains(element.code?.trim()))
        .toList();

    setState(() {
      tenantsList = result;
    });
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
                      padding: EdgeInsets.all(0),
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
                                      '${ApplicationLocalizations.of(context).translate(i18.password.UPDATE_PASSWORD)}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  _buildWelcomeMsg(),
                                  _buildTenantDetails(),
                                  _buildOtpView(),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        '${ApplicationLocalizations.of(context).translate(i18.password.UPDATE_PASSWORD_TO_CONTINUE)}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16)),
                                  ),
                                  BuildTextField(
                                    i18.password.CORE_COMMON_NEW_PASSWORD,
                                    newPassword,
                                    isRequired: true,
                                    obscureText: true,
                                    maxLines: 1,
                                    validator: (val) =>
                                        Validators.passwordComparision(
                                            val,
                                            ApplicationLocalizations.of(context)
                                                .translate(i18.password
                                                    .CORE_COMMON_NEW_PASSWORD)),
                                    onChange: saveInput,
                                  ),
                                  BuildTextField(
                                    i18.password
                                        .CORE_COMMON_CONFIRM_NEW_PASSWORD,
                                    confirmPassword,
                                    isRequired: true,
                                    obscureText: true,
                                    maxLines: 1,
                                    validator: (val) =>
                                        Validators.passwordComparision(
                                            val,
                                            ApplicationLocalizations.of(context)
                                                .translate(i18.password
                                                    .CORE_COMMON_CONFIRM_NEW_PASSWORD),
                                            newPassword.text),
                                    onChange: saveInput,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  BottomButtonBar(
                                      ApplicationLocalizations.of(context)
                                          .translate(
                                              i18.password.CHANGE_PASSWORD),
                                     _pinEditingController.text.trim().length != pinLength ? null : updatePassword),
                                  PasswordHint(password)
                                ],
                              ))))),
                  FooterBanner()
                ]),
              ),
            ))));
  }

  Widget _buildTenantDetails() {
    ;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Table(
          border: TableBorder.all(color: Colors.grey, width: 0.3),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [_buildHeader(), ..._buildData()]),
    );
  }

  Widget _buildWelcomeMsg() {
    if (tenantsList == null) return Container();
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(left: 8, bottom: 20, top: 20, right: 8),
          child: Text(
              '${ApplicationLocalizations.of(context).translate(i18.common.DEAR)} ${widget.userDetails.userRequest?.name}, ' +
                  (tenantsList!.length == 1
                      ? '${ApplicationLocalizations.of(context).translate(i18.password.INVITED_TO_SINGLE_GP)}'
                      : '${ApplicationLocalizations.of(context).translate(i18.password.INVITED_TO_GRAMA_SEVA)}'),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).primaryColorLight)),
        ));
  }

  TableRow _buildHeader() {
    var list = [i18.password.GP_NUMBER, i18.password.NAME_GRAM_PANCHAYAT];
    return TableRow(
        decoration: BoxDecoration(color: Color.fromRGBO(238, 238, 238, 1)),
        children: list
            .map((e) => TableCell(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: Text(
                    '${ApplicationLocalizations.of(context).translate(e)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                )))
            .toList());
  }

  List<TableRow> _buildData() {
    var style = TextStyle(fontSize: 16);
    if (tenantsList == null) return <TableRow>[];
    return List.generate(tenantsList!.length, (index) {
      var e = tenantsList![index];
      return TableRow(
          decoration: BoxDecoration(
              color: index % 2 == 0
                  ? Colors.white
                  : Color.fromRGBO(238, 238, 238, 1)),
          children: [
            TableCell(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Text(
                  ApplicationLocalizations.of(context)
                      .translate('${e?.city?.code}'),
                  style: style),
            )),
            TableCell(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                  ApplicationLocalizations.of(context).translate('${e.code}'),
                  style: style),
            ))
          ]);
    });
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
                    text:
                        '+ 91 - ${widget.userDetails.userRequest?.mobileNumber}',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(11, 12, 12, 1)))
              ])),
          Container(
            width: MediaQuery.of(context).size.width < 720
                ? MediaQuery.of(context).size.width - 50
                : 350,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: PinInputTextField(
              cursor: Cursor(
                width: 2,
                height: 25,
                color: Colors.black,
                radius: Radius.circular(1),
                enabled: true,
              ),
              onChanged: (String value){
                  setState(() {
                  });
              },
              pinLength: pinLength,
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
          Visibility(
            child: CountdownTimer(
                controller: timerController, onEnd: onEnd, endTime: endTime),
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: isdisabled,
          ),
          Visibility(
            child: TextButton(
                onPressed: () => {
                      sendOtp(),
                      endTime =
                          DateTime.now().millisecondsSinceEpoch + 1000 * 30,
                      timerController = CountdownTimerController(
                          endTime: endTime, onEnd: onEnd),
                      setState(() {
                        isdisabled = true;
                      }),
                    },
                child: Text(ApplicationLocalizations.of(context)
                    .translate(i18.password.RESENT_OTP))),
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: !isdisabled,
          ),
        ],
      ),
    );
  }

  void updatePassword() async {
    FocusScope.of(context).unfocus();

    if (formKey.currentState!.validate()) {
      var body = {
        "otpReference": _pinEditingController.text.trim(),
        "userName": widget.userDetails.userRequest?.userName,
        "newPassword": newPassword.text.trim(),
        "tenantId": widget.userDetails.userRequest!.roles!
            .where((element) => element.code == 'PROFILE_UPDATE')
            .first
            .tenantId,
        "type": widget.userDetails.userRequest?.type
      };

      try {
        Loaders.showLoadingDialog(context);

        var resetResponse =
            await ResetPasswordRepository().forgotPassword(body, context);
        Navigator.pop(context);

        Provider.of<CommonProvider>(context, listen: false)
          ..walkThroughCondition(true, Constants.HOME_KEY)
          ..walkThroughCondition(true, Constants.CREATE_CONSUMER_KEY)
          ..walkThroughCondition(true, Constants.ADD_EXPENSE_KEY);

        Navigator.pushNamed(context, Routes.DEFAULT_PASSWORD_UPDATE);
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
    var languagteProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    var body = {
      "otp": {
        "mobileNumber": widget.userDetails.userRequest?.userName,
        "tenantId": widget.userDetails.userRequest?.tenantId,
        "type": "passwordreset",
        "locale": languagteProvider.selectedLanguage?.value,
        "userType": widget.userDetails.userRequest?.type
      }
    };

    try {
      var otpResponse = await ForgotPasswordRepository()
          .forgotPassword(body, widget.userDetails.accessToken);
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
  }
}
