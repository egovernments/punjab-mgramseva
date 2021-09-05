import 'dart:async';
import 'package:mgramseva/model/userProfile/user_profile.dart';
import 'package:mgramseva/repository/user_edit_profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

class UserEditProfileProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();

  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> editUserProfileDetails(body, BuildContext context) async {
    try {
      Loaders.showLoadingDialog(context);

      var edituserResponse =
          await UserEditProfileRepository().editProfile(body);
      Navigator.pop(context);
      if (edituserResponse != null) {
        Notifiers.getToastMessage(
            context, i18.profileEdit.PROFILE_EDIT_SUCCESS, 'SUCCESS');
        streamController.add(edituserResponse);
        new Future.delayed(const Duration(seconds: 5),
              () => Navigator.pop(context),
        );
      }
    } catch (e, s) {
      Navigator.pop(context);
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
  }

  Future<void> getEditUser() async {
    try {
      streamController.add(User());
    } catch (e) {
      streamController.addError('error');
    }
  }

  void onChangeOfGender(String gender, User user) {
    user.gender = gender;
    notifyListeners();
  }
}
