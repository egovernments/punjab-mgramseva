
import 'package:flutter/material.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/global_variables.dart';

class CommonMethods {

  static home(){
    Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, Routes.HOME, (route) => false, arguments: null);
  }


  static String getExtension(String url){
    return url.substring(0, url.indexOf('?')).split('/').last;
  }
}