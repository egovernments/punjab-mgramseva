import 'package:flutter/material.dart';
import 'package:mgramseva/model/changePasswordDetails/changePassword_details.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/changePassword_details_provider.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/utils/validators/Validators.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/Button.dart';
import 'package:mgramseva/widgets/CommonSuccessPage.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/PasswordHint.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
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
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  saveInput(context) async {
    setState(() {
      password = context;
    });
  }

  afterViewBuild() {
    var passwordProvider =
        Provider.of<ChangePasswordProvider>(context, listen: false);
    passwordProvider.getChangePassword();
  }

  saveInputandchangepass(
      context, passwordDetails, ChangePasswordDetails password) async {
    var changePasswordProvider =
        Provider.of<ChangePasswordProvider>(context, listen: false);
    if(formKey.currentState!.validate()) {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    var data = {
        "userName": commonProvider.userDetails!.userRequest!.userName,
        "existingPassword": password.existingPassword,
        "newPassword": password.newPassword,
        "tenantId": commonProvider.userDetails!.userRequest!.tenantId,
        "type": commonProvider.userDetails!.userRequest!.type
      };

      changePasswordProvider.changePassword(data);
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) {
      return CommonSuccess(i18.profileEdit.PROFILE_EDIT_SUCCESS, i18.profileEdit.PROFILE_EDITED_SUCCESS_SUBTEXT, i18.common.BACK_HOME ,() => Home());
        }));
    }
    else{
      changePasswordProvider.autoValidation = true;
      changePasswordProvider.callNotifyer();
    }
  }

  Widget builduserView(ChangePasswordDetails passwordDetails) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeBack(),
          Consumer<ChangePasswordProvider>(
            builder: (_, changePasswordProvider, child) => Form(
              key: formKey,
              autovalidateMode: changePasswordProvider.autoValidation ? AutovalidateMode.always : AutovalidateMode.disabled,
              child: Card(
                  child: Column(
                children: [
                  BuildTextField(
                    i18.password.CURRENT_PASSWORD,
                    passwordDetails.currentpasswordCtrl,
                    isRequired: true,
                    onChange: (value) => saveInput(value),
                  ),
                  BuildTextField(
                    i18.password.NEW_PASSWORD,
                    passwordDetails.newpasswordCtrl,
                    isRequired: true,
                    validator: (val) => Validators.passwordComparision(val, 'Please enter New password'),
                    onChange: (value) => saveInput(value),
                  ),
                  BuildTextField(
                    i18.password.CONFIRM_PASSWORD,
                    passwordDetails.confirmpasswordCtrl,
                    isRequired: true,
                    validator: (val) => Validators.passwordComparision(val, 'Please enter Confirm password', passwordDetails.newpasswordCtrl.text),
                    onChange: (value) => saveInput(value),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Button(
                      i18.password.CHANGE_PASSWORD,
                      () => saveInputandchangepass(
                          context, passwordDetails.getText(), passwordDetails)),
                  PasswordHint(password)
                ],
              )),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var changePasswordProvider =
        Provider.of<ChangePasswordProvider>(context, listen: false);
    return Scaffold(
        appBar: BaseAppBar(
          Text(i18.common.MGRAM_SEVA),
          AppBar(),
          <Widget>[Icon(Icons.more_vert)],
        ),
        drawer: DrawerWrapper(
          Drawer(child: SideBar()),
        ),
        body: SingleChildScrollView(
            child: StreamBuilder(
                stream: changePasswordProvider.streamController.stream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return builduserView(snapshot.data);
                  } else if (snapshot.hasError) {
                    return Notifiers.networkErrorPage(context, () {});
                  } else {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Loaders.CircularLoader();
                      case ConnectionState.active:
                        return Loaders.CircularLoader();
                      default:
                        return Container();
                    }
                  }
                })));
  }
}
