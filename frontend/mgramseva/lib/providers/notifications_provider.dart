import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/Events/events_List.dart';

import 'package:mgramseva/repository/core_repo.dart';

class NotificationProvider with ChangeNotifier {
  var enableNotification = false;
  var streamController = StreamController.broadcast();
  void getNotiications(query1, query2) async {
    try {
      var notifications1 = await CoreRepository().fetchNotifications(query1);
      var notifications2 = await CoreRepository().fetchNotifications(query2);
      List<Events> res = []
        ..addAll(notifications2!.events!)
        ..addAll(notifications1!.events!);

      // print(notifications2);
      print(res.length);
      if (res.length > 0) {
        streamController.add(res);
        enableNotification = true;
      }
    } catch (e) {
      print(e);
    }
  }

  dispose() {
    streamController.close();
    super.dispose();
  }
}
