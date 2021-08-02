import 'package:flutter/material.dart';
import 'package:mgramseva/repository/forgot_password_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/notifyers.dart';
class ForgotPasswordProvider with ChangeNotifier {
  otpforresetpassword(BuildContext context, String mobileNumber) async {

    /// Unfocus the text field
    FocusScope.of(context).unfocus();

    try{
      var body = {
        "otp": {
          "mobileNumber": mobileNumber,
          "tenantId":"pb",
          "type":"passwordreset",
          "userType":"EMPLOYEE"
        }
      };

      var otpResponse = await ForgotPasswordRepository().forgotPassword(body);
      Navigator.pop(context);

      if(otpResponse != null){
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.RESET_PASSWORD, (route) => false);
      }else{
        Notifiers.getToastMessage('Error');
      }
    }  catch(e) {
      Navigator.pop(context);
      Notifiers.getToastMessage('Error');
    }
  }

  void callNotifyer(){
    notifyListeners();
  }
}