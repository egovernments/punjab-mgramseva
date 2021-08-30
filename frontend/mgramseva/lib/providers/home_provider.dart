import 'package:flutter/material.dart';
import 'package:mgramseva/screeens/HomeWalkThrough/HomeWalkThroughList.dart';

class HomeProvider with ChangeNotifier {
  late List<HomeWalkWidgets> homeWalkthrougList;
  int activeindex = 0;

  void setwalkthrough(value) {
    homeWalkthrougList = value;
  }

  incrementindex(index, homeKey) async {
    activeindex = index + 1;
    await Scrollable.ensureVisible(homeKey.currentContext!,
        duration: new Duration(milliseconds: 100));
  }
}
