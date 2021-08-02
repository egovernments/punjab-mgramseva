import 'package:flutter/material.dart';
import 'package:mgramseva/repository/reset_password_repo.dart';
import 'package:mgramseva/utils/notifyers.dart';
class ResetPasswordProvider with ChangeNotifier {
  resetpassword(BuildContext context, String otp1,String otp2,String otp3,String otp4, String newPassword) async {

    /// Unfocus the text field
    FocusScope.of(context).unfocus();

    try{
      var body = {
        "otpReference": otp1+otp2+otp3+otp4,
        "userName":"9191919149",
        "newPassword": newPassword,
        "tenantId":"pb",
        "type":"EMPLOYEE"
      };

      var resetResponse = await ResetPasswordRepository().forgotPassword(body);
      Navigator.pop(context);

      /*if(resetResponse != null){

      }else{
        Notifiers.getToastMessage('Error');
      }*/
    }  catch(e) {
      Navigator.pop(context);
      Notifiers.getToastMessage('Error');
    }
  }

  void callNotifyer(){
    notifyListeners();
  }
}