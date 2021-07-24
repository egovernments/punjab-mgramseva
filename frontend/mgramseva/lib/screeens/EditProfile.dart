import 'package:flutter/material.dart';
import 'package:mgramseva/model/userProfile/user_profile.dart';
import 'package:mgramseva/providers/user_profile_provider.dart';
import 'package:mgramseva/screeens/Changepassword.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/widgets/RadioButtonFieldBuilder.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/homeBack.dart';
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

  afterViewBuild() {
    var userProvider = Provider.of<UserProfileProvider>(context, listen: false);
    userProvider.getUserProfileDetails({
      "tenantId": "pb",
      "id": [92],
      "mobileNumber": "8004375123"
    });
  }

  Widget _builduserView(User profileDetails) {
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
                'Name',
                profileDetails.nameCtrl,
                isRequired: true,
              ),
              BuildTextField(
                'Phone Number',
                profileDetails.phoneNumberCtrl,
                isRequired: true,
              ),
              Consumer<UserProfileProvider>(
                builder : (_, userProvider, child ) => RadioButtonFieldBuilder(context, 'Gender', profileDetails.gender, '', '', true,
                    Constants.GENDER, (val) => userProvider.onChangeOfGender(val, profileDetails),
                )),
              BuildTextField(
                'Email ID',
                profileDetails.emailIdCtrl,
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
                          'Change Password',
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
                    onPressed: () => {},
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
    var userProvider = Provider.of<UserProfileProvider>(context, listen: false);

    return SingleChildScrollView(
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
            }));
  }
}
