import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/repository/changePassword_details_repo.dart';

class ChangePasswordProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();

  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> changePassword(body) async {
    try {
      var changePasswordResponse = await ChangePasswordRepository().updatePassword(body);
      if (changePasswordResponse != null) {
        streamController.add(changePasswordResponse);
      }
    } catch (e) {
      print(e);
      streamController.addError('error');
    }
  }
}