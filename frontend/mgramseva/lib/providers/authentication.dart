
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mgramseva/repository/authentication.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';

class AuthenticationProvider with ChangeNotifier {


  validateLogin(BuildContext context, String userName, String password) async {

    /// Unfocus the text field
    FocusScope.of(context).unfocus();

    try{
      var body = {
        "username" : userName,
        "password": password,
        "scope": "read",
        "grant_type": "password",
        "tenantId": "pb",
        "userType": "EMPLOYEE"
      };

      var  headers = {
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
        "Access-Control-Allow-Origin": "*",
        "authorization": "Basic ZWdvdi11c2VyLWNsaWVudDo=",
    };

      Loaders.showLoadingDialog(context, label : 'Validating the Credentials');

      var loginResponse = await AuthenticationRepository().validateLogin(body, headers);

      Navigator.pop(context);
      if(loginResponse != null){
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) {
              return Home(0);
        }));
      }else{
        Notifiers.getToastMessage('Unable to login');
      }
    } catch(e) {
      Navigator.pop(context);
      Notifiers.getToastMessage('Unable to login');
    }
  }


}