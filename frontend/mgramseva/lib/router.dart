import 'package:flutter/material.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/screeens/Login/Login.dart';
import 'package:mgramseva/screeens/SelectLanguage/languageSelection.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  /// Here we'll handle all the routing


  switch (settings.name) {
    case Routes.LOGIN :
      return MaterialPageRoute(builder: (_) => Login());
    case Routes.HOME :
      return MaterialPageRoute(builder: (_) => Home(0));
    default :
      return MaterialPageRoute(builder: (_) => SelectLanguage((){}));
  }
  }