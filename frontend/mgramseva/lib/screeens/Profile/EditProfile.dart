import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/model/userProfile/user_profile.dart';
import 'package:mgramseva/providers/user_edit_profile_provider.dart';
import 'package:mgramseva/providers/user_profile_provider.dart';
import 'package:mgramseva/screeens/ChangePassword/Changepassword.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/validators/Validators.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/CommonSuccessPage.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/RadioButtonFieldBuilder.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:provider/provider.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/providers/common_provider.dart';

class EditProfile extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    print(commonProvider.userDetails!.userRequest!.tenantId);
    Provider.of<UserProfileProvider>(context, listen: false)
      ..formKey = GlobalKey<FormState>()
      ..autoValidation = false
      ..getUserProfileDetails({
        "tenantId": commonProvider.userDetails!.userRequest!.tenantId,
        "id": [commonProvider.userDetails!.userRequest!.id],
        "mobileNumber": commonProvider.userDetails!.userRequest!.mobileNumber
      });
  }

  saveInputandedit(context, profileDetails, User profile) async {
    var userProvider = Provider.of<UserProfileProvider>(context, listen: false);

    if (userProvider.formKey.currentState!.validate()) {
      var editProfileProvider =
          Provider.of<UserEditProfileProvider>(context, listen: false);
      editProfileProvider.editUserProfileDetails({"user": profile.toJson()});
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context) {
        return CommonSuccess(SuccessHandler(
            i18.profileEdit.PROFILE_EDIT_SUCCESS,
            i18.profileEdit.PROFILE_EDITED_SUCCESS_SUBTEXT, i18.common.BACK_HOME));
      }));
    } else {
      userProvider.autoValidation = true;
      userProvider.callNotfyer();
    }
  }

  Widget _builduserView(User profileDetails) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeBack(),
          Consumer<UserProfileProvider>(
            builder: (_, userProvider, child) => Form(
              autovalidateMode: userProvider.autoValidation
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              key: userProvider.formKey,
              child: Card(
                  child: Column(
                children: [
                  BuildTextField(
                    i18.common.NAME,
                    profileDetails.nameCtrl,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                    ],
                    isRequired: true,
                  ),
                  BuildTextField(
                    i18.common.PHONE_NUMBER,
                    profileDetails.phoneNumberCtrl,
                    prefixText: '+91',
                    isRequired: true,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    maxLength: 10,
                    validator: Validators.mobileNumberValidator,
                    textInputType: TextInputType.phone,
                    isDisabled: true,
                  ),
                  RadioButtonFieldBuilder(
                    context,
                    'Gender',
                    profileDetails.gender,
                    '',
                    '',
                    false,
                    Constants.GENDER,
                    (val) => userProvider.onChangeOfGender(val, profileDetails),
                  ),
                  BuildTextField(
                    i18.common.EMAIL,
                    profileDetails.emailIdCtrl,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@. ]"))
                    ],
                    message: 'Invalid email format, example@mail.com',
                    pattern:
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ChangePassword())),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, top: 10, bottom: 10, right: 25),
                        child: new Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              i18.password.CHANGE_PASSWORD,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ))),
                  ),
                  FractionallySizedBox(
                      widthFactor: 0.90,
                      child: new ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                        ),
                        child: new Text(i18.common.SAVE,
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w500)),
                        onPressed: () => saveInputandedit(
                            context, profileDetails.getText(), profileDetails),
                      )),
                  SizedBox(
                    height: 20,
                  )
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
    var userProvider = Provider.of<UserProfileProvider>(context, listen: false);

    return Scaffold(
      appBar : BaseAppBar(
        Text(i18.common.MGRAM_SEVA),
        AppBar(),
        <Widget>[Icon(Icons.more_vert)],
      ),
      body: Container(
        alignment: Alignment.center,
        child: StreamBuilder(
            stream: userProvider.streamController.stream,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return _builduserView(snapshot.data);
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
            }),
      ),
    );
  }
}
