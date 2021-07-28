import 'package:flutter/material.dart';
import 'package:mgramseva/model/userEditProfile/user_edit_profile.dart';
import 'package:mgramseva/providers/user_edit_profile_provider.dart';
import 'package:mgramseva/screeens/Changepassword.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/RadioButtonFieldBuilder.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:provider/provider.dart';
import 'package:mgramseva/utils/notifyers.dart';

class EditProfile extends StatefulWidget {
  static const String routeName = 'editProfile';
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  var name = new TextEditingController();
  var phoneNumber = new TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  /*afterViewBuild() {
    var userProvider = Provider.of<UserProfileProvider>(context, listen: false);
    userProvider.getUserProfileDetails({
      "tenantId": "pb",
      "id": [117],
      "mobileNumber": "9191919149"
    });
  }*/
  afterViewBuild() {
    var editProvider = Provider.of<UserEditProfileProvider>(context, listen: false);
    editProvider.getEditUser();
  }

  saveInputandedit(context, editUserChanges, EditUser editUser) async {
    var edituserProvider = Provider.of<UserEditProfileProvider>(context, listen: false);
    var data = {
      "user":   {
        "id": 117,
        "userName": "gpadmin3",
        "salutation": null,
        "name": editUser.name,
        "gender": "MALE",
        "mobileNumber": "9191919149",
        "emailId": editUser.emailId,
        "active": true,
        "type": "EMPLOYEE",
        "accountLocked": false,
        "accountLockedDate": 0,
        "createdBy": 92,
        "lastModifiedBy": 92,
        "tenantId": "pb",

        "roles": [
          {
            "code": "GP_ADMIN",
            "name": "GP Admin",
            "tenantId": "pb.lodhipur"
          },
          {
            "code": "EMPLOYEE",
            "name": "Employee",
            "tenantId": "pb.lodhipur"
          },
          {
            "code": "EMPLOYEE",
            "name": "Employee",
            "tenantId": "pb.sukhsal"
          }
        ],
        "uuid": "7ebc0c21-4cc2-4a0b-9a8f-e6001adcf064"
      }
    };
    edituserProvider.editUserProfileDetails(data);
  }

  Widget _builduserView(EditUser editUserChanges) {
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
                i18.common.NAME,
                editUserChanges.nameCtrl,
                isRequired: true,
              ),
              BuildTextField(
                i18.common.PHONE_NUMBER,
                editUserChanges.phoneNumberCtrl,
                isRequired: true,
              ),
              Consumer<UserEditProfileProvider>(
                builder : (_, userProvider, child ) => RadioButtonFieldBuilder(context, 'Gender', editUserChanges.gender, '', '', true,
                    Constants.GENDER, (val) => userProvider.onChangeOfGender(val, editUserChanges),
                )),
              BuildTextField(
                i18.common.EMAIL,
                editUserChanges.emailIdCtrl,
                isRequired: true,
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
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))),
              ),
              FractionallySizedBox(
                  widthFactor: 0.90,
                  child: new ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15),
                    ),
                    child: new Text('Save',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w500)),
                    onPressed: () => {saveInputandedit(context, editUserChanges.getText(), editUserChanges)},
                  )),
              SizedBox(
                height: 20,
              )
            ],
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var edituserProvider = Provider.of<UserEditProfileProvider>(context, listen: false);

    return SingleChildScrollView(
        child: StreamBuilder(
            stream: edituserProvider.streamController.stream,
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
            }));
  }
}
