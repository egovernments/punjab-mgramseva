import 'dart:async';

import 'package:mgramseva/model/userProfile/user_profile.dart';
import 'package:mgramseva/repository/user_edit_profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/CommonSuccessPage.dart';

class UserEditProfileProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();

  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> editUserProfileDetails(body, context) async {
    try {
      Loaders.showLoadingDialog(context);
      var edituserResponse =
          await UserEditProfileRepository().editProfile(body);
      Navigator.pop(context);
      if (edituserResponse != null) {
        Notifiers.getToastMessage(
            context, i18.profileEdit.PROFILE_EDIT_SUCCESS, 'SUCCESS');
        streamController.add(edituserResponse);
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
      streamController.addError('error');
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
