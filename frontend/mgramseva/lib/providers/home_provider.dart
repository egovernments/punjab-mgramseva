import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/screeens/HomeWalkThrough/HomeWalkThroughList.dart';
import 'package:mgramseva/utils/role_actions.dart';

class HomeProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  List<HomeWalkWidgets> homeWalkthrougList =
      HomeWalkThrough().homeWalkThrough.map((e) {
    e.key = GlobalKey();
    return e;
  }).toList();
  int activeindex = 0;

  void setwalkthrough(value) {
    homeWalkthrougList = value
        .where((element) => RoleActionsFiltering()
            .getFilteredModules()
            .where((ele) => ele.label == element.label)
            .isNotEmpty)
        .toList();
  }

  incrementindex(index, homeKey) async {
    activeindex = index + 1;
    await Scrollable.ensureVisible(homeKey.currentContext!,
        duration: new Duration(milliseconds: 100));
  }

  dispose() {
    streamController.close();
    super.dispose();
  }

  void updateWalkThrough(value) {
    homeWalkthrougList = value;
  }
}
