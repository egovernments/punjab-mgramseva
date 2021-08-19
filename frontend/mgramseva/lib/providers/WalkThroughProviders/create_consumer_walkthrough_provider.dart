import 'package:flutter/material.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../consumer_details_provider.dart';
class ConsumerWalkThroughProvider with ChangeNotifier{
  final GlobalKey consumerNameKey = GlobalKey();
  final GlobalKey consumerGenderKey = GlobalKey();
  final GlobalKey consumerFatherKey = GlobalKey();
  final GlobalKey consumerPhoneKey = GlobalKey();
  final GlobalKey consumerOldIDKey = GlobalKey();
  final GlobalKey consumerWardKey = GlobalKey();
  final GlobalKey consumerPropertyKey = GlobalKey();
  final GlobalKey consumerServiceKey = GlobalKey();
  final GlobalKey consumerArrearsKey = GlobalKey();
  BuildContext? consumerContext;
  var consumerProvider = Provider.of<ConsumerProvider>(
      navigatorKey.currentContext!,
      listen: false);

  showCaseEvent(){
    ShowCaseWidget.of(consumerContext!)!.startShowCase([
      consumerNameKey
    ]);
  }
  genderShowCase() {
    ShowCaseWidget.of(consumerContext!)!.startShowCase([
      consumerGenderKey
    ]);
  }
  fatherNameShowCase(){
    Future.delayed(const Duration(milliseconds: 100), () async { // wait 1 second until component is loaded, then scroll
      await Scrollable.ensureVisible(consumerGenderKey.currentContext!,duration: new Duration(milliseconds:100));
      ShowCaseWidget.of(consumerContext!)!.startShowCase([consumerFatherKey]);
    });
  }
  phoneShowCase() {
    Future.delayed(const Duration(milliseconds: 100), () async {
      await Scrollable.ensureVisible(consumerFatherKey.currentContext!,duration: new Duration(milliseconds:100));
      ShowCaseWidget.of(consumerContext!)!.startShowCase([consumerPhoneKey]);
    });
  }
  oldIDShowCase() {
    ShowCaseWidget.of(consumerContext!)!.startShowCase([
      consumerOldIDKey
    ]);
  }
  wardOrPropertyShowcase() {
    if(consumerProvider.boundaryList.length > 0)
    {
      Future.delayed(const Duration(milliseconds: 100), () async {
        await Scrollable.ensureVisible(consumerOldIDKey.currentContext!,duration: new Duration(milliseconds:100));
        ShowCaseWidget.of(consumerContext!)!.startShowCase([consumerWardKey]);
      });
    }
    else {
      Future.delayed(const Duration(milliseconds: 100), () async {
        await Scrollable.ensureVisible(consumerOldIDKey.currentContext!,duration: new Duration(milliseconds:100));
        ShowCaseWidget.of(consumerContext!)!.startShowCase([consumerPropertyKey]);
      });
    }
  }
  propertyShowCase(){
    Future.delayed(const Duration(milliseconds: 100), () async {
      await Scrollable.ensureVisible(consumerWardKey.currentContext!,duration: new Duration(milliseconds:100));
      ShowCaseWidget.of(consumerContext!)!.startShowCase([consumerPropertyKey]);
    });
  }
  serviceShowCase() {
    Future.delayed(const Duration(milliseconds: 100), () async {
      await Scrollable.ensureVisible(consumerPropertyKey.currentContext!,duration: new Duration(milliseconds:100));
      ShowCaseWidget.of(consumerContext!)!.startShowCase([consumerServiceKey]);
    });
  }

  arrearsShowCase() {
    Future.delayed(const Duration(milliseconds: 100), () async {
      await Scrollable.ensureVisible(consumerServiceKey.currentContext!,duration: new Duration(milliseconds:200));
      ShowCaseWidget.of(consumerContext!)!.startShowCase([consumerArrearsKey]);
    });
  }
  skipFun(){
    ShowCaseWidget.of(consumerContext!)!.dismiss();
  }
}
