import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/changePasswordDetails/changePassword_details.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/repository/changePassword_details_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/custom_exception.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/CommonSuccessPage.dart';
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
      Loaders.showLoadingDialog(context);

      var changePasswordResponse = await ChangePasswordRepository().updatePassword(body);
      Navigator.pop(context);
      if (changePasswordResponse != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.SUCCESS_VIEW, (route) => false,
            arguments: SuccessHandler(
                i18.profileEdit.PROFILE_EDIT_SUCCESS,
                i18.profileEdit.PROFILE_EDITED_SUCCESS_SUBTEXT,
                i18.common.BACK_HOME,
                Routes.CHANGE_PASSWORD));
      }
    } catch (e, s) {
      Navigator.pop(context);
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
  }

  callNotifyer() {
    notifyListeners();
  }
}
