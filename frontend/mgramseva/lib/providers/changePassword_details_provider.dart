import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/changePasswordDetails/changePassword_details.dart';
import 'package:mgramseva/model/connection/house_connection.dart';
import 'package:mgramseva/repository/changePassword_details_repo.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/widgets/CommonSuccessPage.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

class ChangePasswordProvider with ChangeNotifier {
  var formKey = GlobalKey<FormState>();
  var autoValidation = false;
  var changePasswordDetails = ChangePasswordDetails();


  Future<void> changePassword(body, BuildContext context) async {
    try {
      Loaders.showLoadingDialog(navigatorKey.currentContext!);

      var changePasswordResponse = await ChangePasswordRepository().updatePassword(body);
      navigatorKey.currentState?.pop();
      if (changePasswordResponse != null) {
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) {
          return CommonSuccess(SuccessHandler(i18.profileEdit.PROFILE_EDIT_SUCCESS, i18.profileEdit.PROFILE_EDITED_SUCCESS_SUBTEXT, i18.common.BACK_HOME));
        }));
      }
    } catch (e) {
      navigatorKey.currentState?.pop();
    }
  }

  callNotifyer() {
    notifyListeners();
  }

}

