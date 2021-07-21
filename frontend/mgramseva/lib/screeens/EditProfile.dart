import 'package:flutter/material.dart';
import 'package:mgramseva/screeens/Changepassword.dart';
import 'package:mgramseva/widgets/RadioButtonFieldBuilder.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/homeBack.dart';

class EditProfile extends StatefulWidget {
  static const String routeName = 'editProfile';
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  List<Map<String, dynamic>> options = [
    {"key": "MALE", "label": "Male"},
    {"key": "FEMALE", "label": "Female"},
    {"key": "Transgender", "label": "Transgender "}
  ];
  var name = new TextEditingController();
  var phoneNumber = new TextEditingController();
  String _gender = 'FEMALE';

  final formKey = GlobalKey<FormState>();
  saveInput(context) async {
    print(context);
    setState(() {
      _gender = context;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_gender);
    return SingleChildScrollView(
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeBack(),
          Card(
              child: Column(
            children: [
              BuildTextField(context, 'Name', name, '', '', saveInput, true),
              BuildTextField(context, 'Phone Number', phoneNumber, '', '',
                  saveInput, true),
              RadioButtonFieldBuilder(
                  context, 'Gender', _gender, '', '', true, options, saveInput),
              BuildTextField(
                  context, 'Email ID', phoneNumber, '', '', saveInput, true),
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
      )),
    );
  }
}
