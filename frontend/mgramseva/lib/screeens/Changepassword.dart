import 'package:flutter/material.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/services/user.dart';
//import 'package:mgramseva/screeens/home.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/PasswordHint.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
//import 'package:mgramseva/widgets/homeBack.dart';
//import 'package:mgramseva/widgets/passwordHint.dart';

import 'Home.dart';

class ChangePassword extends StatefulWidget {
  static const String routeName = '/changepassword';

  State<StatefulWidget> createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePassword> {
  var password = "";
  var name = new TextEditingController();
  var newpassword = new TextEditingController();
  var confirmpassword = new TextEditingController();

  final formKey = GlobalKey<FormState>();
  saveInput(context) async {
    setState(() {
      password = context;
    });
  }

  saveInputandchangepass(context) async {
    var data =
      {
        "existingPassword": "eGov@123",
        "newPassword": "eGov@1234",
        "mobileNumber": "9191919146",
        "tenantId": "pb",
        "type": "EMPLOYEE"
      };
    updatepassword(data, context);

  }

  _onSelectItem(int index, context) {
    print(index);
    print(Routes.home);
    // setState(() => _selectedDrawerIndex = index);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Home(index),
        ),
        ModalRoute.withName(Routes.home));
    //  Navigator.push<bool>(
    //                                   context,
    //                                   MaterialPageRoute(
    //                                       builder: (BuildContext context) =>
    //                                           Home(index)));
// close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          Text('mGramSeva'),
          AppBar(),
          <Widget>[Icon(Icons.more_vert)],
        ),
        drawer: Container(
          width: MediaQuery.of(context).size.width * .7,
          margin: EdgeInsets.only(top: 60),
          child:
              Drawer(child: SideBar((value) => _onSelectItem(value, context))),
        ),
        body: SingleChildScrollView(
            child: FormWrapper(Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              HomeBack(),
              Container(
                  child: Column(
                children: [
                  Card(
                      child: Column(
                    children: [
                      BuildTextField(
                        'Current  Password',
                        name,
                        isRequired: true,
                        //onChange: saveInput(context),
                      ),
                      BuildTextField(
                        ' Set a New Password',
                        newpassword,
                        isRequired: true,
                      ),
                      BuildTextField(
                        'Confirm New Password',
                        confirmpassword,
                        isRequired: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      PasswordHint(password)
                    ],
                  ))
                ],
              ))
            ]))),
        bottomNavigationBar: BottomButtonBar('Submit', () => saveInputandchangepass(context)));
  }
}
