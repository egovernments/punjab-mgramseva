import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/userProfile/user_profile.dart';

class UserProfileProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();

  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> getUserProfileDetails() async {
    try {
      streamController.add(UserProfile());
    } catch (e) {
      streamController.addError('error');
    }
  }
}
