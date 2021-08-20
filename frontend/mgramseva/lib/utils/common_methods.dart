
import 'package:flutter/material.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/global_variables.dart';

class CommonMethods {

  static home(){
    Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, Routes.HOME, (route) => false, arguments: null);
  }

 static List<DateTime> getPastMonthUntilFinancialYear(){
     var monthList = <DateTime>[];
    if(DateTime.now().month >= 3){
      for(int i = 3; i <= DateTime.now().month; i++){
        monthList.add(DateTime(DateTime.now().year, i));
      }
    }else {
      for(int i = 3; i <= 12; i++){
        monthList.add(DateTime(DateTime.now().year - 1, i));
      }
      for(int i = 1; i <= DateTime.now().month; i++){
        monthList.add(DateTime(DateTime.now().year, i));
      }
    }
    return monthList;
  }
}