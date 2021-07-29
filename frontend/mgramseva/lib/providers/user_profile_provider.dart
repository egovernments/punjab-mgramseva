import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/userProfile/user_profile.dart';
import 'package:mgramseva/repository/user_profile_repo.dart';

class UserProfileProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();

  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> getUserProfileDetails(body) async {
    try {
      var userResponse = await UserProfileRepository().getProfile(body);
      if (userResponse != null) {
        streamController.add(userResponse.user?.first);
      }
    } catch (e) {
      print("its an error");
      print(e);
      streamController.addError('error');
    }
  }

  void onChangeOfGender(String gender, User user) {
    user.gender = gender;
    notifyListeners();
  }
}
