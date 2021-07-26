import 'package:flutter/material.dart';
import 'package:mgramseva/model/changePasswordDetails/changePassword_details.dart';
import 'package:mgramseva/providers/changePassword_details_provider.dart';
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
    super.initState();
  }

  saveInput(context) async {
    setState(() {
      password = context;
    });
  }

  saveInputandchangepass(context) async {
    var changePasswordProvider = Provider.of<ChangePasswordProvider>(context, listen: false);
    changePasswordProvider.changePassword(
        {
          "existingPassword":"PGLME16",
          "newPassword":"eGov@1234",
          "tenantId":"pb",
          "type":"EMPLOYEE"
        });
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
                    'Current  Password',
                    passwordDetails.currentpasswordCtrl,
                    isRequired: true,
                    //onChange: saveInput(context),
                  ),
                  BuildTextField(
                    ' Set a New Password',
                    passwordDetails.newpasswordCtrl,
                    isRequired: true,
                  ),
                  BuildTextField(
                    'Confirm New Password',
                    passwordDetails.confirmpasswordCtrl,
                    isRequired: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Button('Change Password', () => saveInputandchangepass(context)),
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
