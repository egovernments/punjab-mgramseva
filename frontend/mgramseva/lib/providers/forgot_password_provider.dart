import 'package:flutter/material.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/repository/forgot_password_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';

import 'common_provider.dart';

class ForgotPasswordProvider with ChangeNotifier {
  otpforresetpassword(BuildContext context, String mobileNumber) async {
    /// Unfocus the text field
    FocusScope.of(context).unfocus();

    try {
      var languageProvider =
          Provider.of<LanguageProvider>(context, listen: false);
      print(mobileNumber);
      print(languageProvider.stateInfo!.code);
      var body = {
        "otp": {
          "mobileNumber": mobileNumber,
          "tenantId": languageProvider.stateInfo!.code,
          "type": "passwordreset",
          "userType": "Employee"
        }
      };

      Loaders.showLoadingDialog(context);

      var otpResponse =
          await ForgotPasswordRepository().forgotPassword(body, context);
      print(otpResponse);
      Navigator.pop(context);

      if (otpResponse != null) {
        Navigator.of(context)
            .pushNamed(Routes.RESET_PASSWORD, arguments: {"id": mobileNumber});
      }
    } catch (e, s) {
      print(e);
      Navigator.pop(context);
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
  }

  void callNotifyer() {
    notifyListeners();
  }
}
