import 'package:flutter/material.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/providers/user_profile_provider.dart';
import 'package:mgramseva/widgets/LanguageCard.dart';
import 'package:provider/provider.dart';

class SideBar extends StatelessWidget {
  final Function _onSelectItem;

  SideBar(this._onSelectItem);



  @override
  Widget build(BuildContext context) {

    const iconColor = Color(0xff505A5F);
    return new ListView(children: <Widget>[
      Container(
          height: 200.0,
          color: Color(0xffD6D5D4),
          child: DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  'Harpreet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                )),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: Text(
                  '9535676456',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ))
              ],
            ),
          ),
          margin: EdgeInsets.all(0.0),
          padding: EdgeInsets.all(0.0)),
      ListTile(
        title: Text('Home'),
        leading: Icon(
          Icons.home,
          color: iconColor,
        ),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          _onSelectItem(0);
        },
      ),
      ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text('Language'),
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (var language in Provider.of<LanguageProvider>(context, listen: false).stateInfo?.languages ?? [])
                LanguageCard(language, Provider.of<LanguageProvider>(context, listen: false).stateInfo?.languages ?? [], 20, 5, 5,
                   )
            ])
          ],
        ),
        leading: Icon(
          Icons.translate,
          color: iconColor,
        ),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer

          Navigator.pop(context);
        },
      ),
      ListTile(
        title: Text('Edit Profile'),
        leading: Icon(
          Icons.assignment_ind,
          color: iconColor,
        ),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          _onSelectItem(2);
        },
      ),
      ListTile(
        title: Text('Log Out'),
        leading: Icon(
          Icons.logout,
          color: iconColor,
        ),
        onTap: () {
          var commonProvider = Provider.of<CommonProvider>(context, listen: false);
          commonProvider.onLogout();
        },
      ),
    ]);
  }
}
