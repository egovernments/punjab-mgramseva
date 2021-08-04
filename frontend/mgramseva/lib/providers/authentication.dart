import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/repository/authentication.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/custom_exception.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';

class AuthenticationProvider with ChangeNotifier {
  validateLogin(BuildContext context, String userName, String password) async {
    /// Unfocus the text field
    FocusScope.of(context).unfocus();

    try {
      var body = {
        "username": userName,
        "password": password,
        "scope": "read",
        "grant_type": "password",
        "tenantId": "pb",
        "userType": "EMPLOYEE"
      };

      var headers = {
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
        "Access-Control-Allow-Origin": "*",
        "authorization": "Basic ZWdvdi11c2VyLWNsaWVudDo=",
      };

      Loaders.showLoadingDialog(context, label: 'Validating the Credentials');

      var loginResponse =
          await AuthenticationRepository().validateLogin(body, headers);

      Navigator.pop(context);
      if (loginResponse != null) {
        var commonProvider =
            Provider.of<CommonProvider>(context, listen: false);
        commonProvider.loginCredentails = loginResponse;

        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.HOME, (route) => false);
      } else {
        Notifiers.getToastMessage(context, 'Unable to login', 'ERROR');
      }
    } on CustomException catch (e) {
      Navigator.pop(context);
      if (e.exceptionType == ExceptionType.UNAUTHORIZED) {
        Notifiers.getToastMessage(
            context, '${e.message ?? "Invalid Credentials"}', 'ERROR');
      } else {
        Notifiers.getToastMessage(context, 'Unable to login', 'ERROR');
      }
    } catch (e) {
      Navigator.pop(context);
      Notifiers.getToastMessage(context, 'Unable to login', 'ERROR');
    }
  }

  void callNotifyer() {
    notifyListeners();
  }
}
