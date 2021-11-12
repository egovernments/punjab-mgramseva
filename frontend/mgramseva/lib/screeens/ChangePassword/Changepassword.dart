import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:mgramseva/model/changePasswordDetails/changePassword_details.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/changePassword_details_provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/validators/Validators.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/PasswordHint.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/footer.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePassword> {
  var password = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    var passwordProvider =
        Provider.of<ChangePasswordProvider>(context, listen: false);
    passwordProvider.changePasswordDetails = ChangePasswordDetails();
    super.initState();
  }

  saveInput(context) async {
    setState(() {
      password = context;
    });
  }

  saveInputandchangepass(
      context, passwordDetails, ChangePasswordDetails password) async {
    var changePasswordProvider =
        Provider.of<ChangePasswordProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      var commonProvider = Provider.of<CommonProvider>(context, listen: false);
      var data = {
        "userName": commonProvider.userDetails!.userRequest!.userName,
        "existingPassword": password.existingPassword,
        "newPassword": password.newPassword,
        "tenantId": commonProvider.userDetails!.selectedtenant!.code,
        "type": commonProvider.userDetails!.userRequest!.type
      };

      changePasswordProvider.changePassword(data, context);
    } else {
      changePasswordProvider.autoValidation = true;
      changePasswordProvider.callNotifyer();
    }
  }

  Widget builduserView(ChangePasswordDetails passwordDetails) {
    return Container(
        child: FormWrapper(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeBack(),
          Consumer<ChangePasswordProvider>(
            builder: (_, changePasswordProvider, child) => Form(
              key: formKey,
              autovalidateMode: changePasswordProvider.autoValidation
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Card(
                  child: Column(
                children: [
                  BuildTextField(
                    i18.password.CURRENT_PASSWORD,
                    passwordDetails.currentpasswordCtrl,
                    obscureText: true,
                    isRequired: true,
                    maxLines: 1,
                    onChange: (value) => saveInput(value),
                  ),
                  BuildTextField(
                    i18.password.NEW_PASSWORD,
                    passwordDetails.newpasswordCtrl,
                    obscureText: true,
                    isRequired: true,
                    maxLines: 1,
                    validator: (val) => Validators.passwordComparision(
                        val,
                        ApplicationLocalizations.of(context)
                            .translate(i18.password.NEW_PASSWORD_ENTER)),
                    onChange: (value) => saveInput(value),
                  ),
                  BuildTextField(
                    i18.password.CONFIRM_PASSWORD,
                    passwordDetails.confirmpasswordCtrl,
                    obscureText: true,
                    isRequired: true,
                    maxLines: 1,
                    validator: (val) => Validators.passwordComparision(
                        val,
                        ApplicationLocalizations.of(context)
                            .translate(i18.password.CONFIRM_PASSWORD_ENTER),
                        passwordDetails.newpasswordCtrl.text),
                    onChange: (value) => saveInput(value),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  PasswordHint(password)
                ],
              )),
            ),
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var changePasswordProvider =
        Provider.of<ChangePasswordProvider>(context, listen: false);
    return FocusWatcher(
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: BaseAppBar(
              Text(i18.common.MGRAM_SEVA),
              AppBar(),
              <Widget>[Icon(Icons.more_vert)],
            ),
            drawer: DrawerWrapper(
              Drawer(child: SideBar()),
            ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                builduserView(changePasswordProvider.changePasswordDetails),
                Footer()
              ],
            )),
            bottomNavigationBar: BottomButtonBar(
                i18.password.CHANGE_PASSWORD,
                () => saveInputandchangepass(
                    context,
                    changePasswordProvider.changePasswordDetails.getText(),
                    changePasswordProvider.changePasswordDetails))));
  }
}
