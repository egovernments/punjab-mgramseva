import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/changePasswordDetails/changePassword_details.dart';
import 'package:mgramseva/repository/changePassword_details_repo.dart';
import 'package:mgramseva/utils/custom_exception.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

class ChangePasswordProvider with ChangeNotifier {
  var formKey = GlobalKey<FormState>();
  var autoValidation = false;
  var changePasswordDetails = ChangePasswordDetails();

  Future<void> changePassword(body, BuildContext context) async {
    try {
      Loaders.showLoadingDialog(navigatorKey.currentContext!);

      var changePasswordResponse =
          await ChangePasswordRepository().updatePassword(body);
      navigatorKey.currentState?.pop();
      if (changePasswordResponse != null) {
        Notifiers.getToastMessage(
            context, i18.common.PROFILE_PASSWORD_SUCCESS_LABEL, 'SUCCESS');
        navigatorKey.currentState?.pop();
      }
    } on CustomException catch (e) {
      Notifiers.getToastMessage(context, e.message.toString(), 'ERROR');
      navigatorKey.currentState?.pop();
    }
  }

  callNotifyer() {
    notifyListeners();
  }
}
