import 'package:flutter/material.dart';
import 'package:mgramseva/model/changePasswordDetails/changePassword_details.dart';
import 'package:mgramseva/providers/changePassword_details_provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/Button.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/PasswordHint.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  static const String routeName = '/changepassword';

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
    var passwordProvider = Provider.of<ChangePasswordProvider>(context, listen: false);
    passwordProvider.getChangePassword();
  }

  saveInputandchangepass(context, passwordDetails, ChangePasswordDetails password) async {
    print(password.existingPassword);
    var changePasswordProvider = Provider.of<ChangePasswordProvider>(context, listen: false);
    var data = {
      "existingPassword": password.existingPassword,
      "newPassword": password.newPassword,
      "tenantId":"pb",
      "type":"EMPLOYEE"
    };

    changePasswordProvider.changePassword(data);
  }


  Widget builduserView(ChangePasswordDetails passwordDetails) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeBack(),
          Card(
              child: Column(
                children: [
                  BuildTextField(
                    i18.password.CURRENT_PASSWORD,
                    passwordDetails.currentpasswordCtrl,
                    isRequired: true,
                    //onChange: saveInput(context),
                  ),
                  BuildTextField(
                    i18.password.NEW_PASSWORD,
                    passwordDetails.newpasswordCtrl,
                    isRequired: true,
                  ),
                  BuildTextField(
                    i18.password.CONFIRM_PASSWORD,
                    passwordDetails.confirmpasswordCtrl,
                    isRequired: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Button(i18.password.CHANGE_PASSWORD, () => saveInputandchangepass(context, passwordDetails.getText(), passwordDetails)),
                  PasswordHint(password)
                ],
              ))
        ],
      ),
    );


  }

  @override
  Widget build(BuildContext context) {
    var changePasswordProvider = Provider.of<ChangePasswordProvider>(context, listen: false);
    return SingleChildScrollView(
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
            }));
  }
}
