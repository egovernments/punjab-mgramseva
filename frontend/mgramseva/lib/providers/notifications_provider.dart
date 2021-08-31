import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mgramseva/repository/core_repo.dart';

class NotificationProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  void getNotiications(query) async {
    try {
      var notifications = await CoreRepository().fetchNotifications(query);
      if (notifications != null) {
        streamController.add(notifications);
      }
    } catch (e) {}
  }

  dispose() {
    streamController.close();
    super.dispose();
  }
}
