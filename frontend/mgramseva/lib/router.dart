import 'package:flutter/material.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/Changepassword.dart';
import 'package:mgramseva/screeens/ConnectionResults.dart';
import 'package:mgramseva/screeens/Dashboard.dart';
import 'package:mgramseva/screeens/EditProfile.dart';
import 'package:mgramseva/screeens/ExpenseDetails.dart';
import 'package:mgramseva/screeens/GenerateBill/GenerateBill.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/screeens/HouseholdDetail.dart';
import 'package:mgramseva/screeens/Login/Login.dart';
import 'package:mgramseva/screeens/ResetPassword/Resetpassword.dart';
import 'package:mgramseva/screeens/SearchConnection.dart';
import 'package:mgramseva/screeens/SelectLanguage/languageSelection.dart';
import 'package:mgramseva/screeens/Updatepassword.dart';

import 'main.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  /// Here we'll handle all the routing


  switch (settings.name) {
    case Routes.LANDING_PAGE:
      return MaterialPageRoute(builder: (_) => LandingPage());
    case Routes.LOGIN :
      return MaterialPageRoute(builder: (_) => Login());
    case Routes.HOME :
      return MaterialPageRoute(builder: (_) => Home(0));
    case Routes.HOUSE_HOLD :
      return MaterialPageRoute(builder: (_) => SearchConnection());
    case Routes.EDIT_PROFILE :
      return MaterialPageRoute(builder: (_) => EditProfile());
    case Routes.CHANGE_PASSWORD :
      return MaterialPageRoute(builder: (_) => ChangePassword());
    case Routes.UPDATE_PASSWORD :
      return MaterialPageRoute(builder: (_) => UpdatePassword());
    case Routes.RESET_PASSWORD :
      return MaterialPageRoute(builder: (_) => ResetPassword());
    case Routes.CONSUMER_SEARCH :
      return MaterialPageRoute(builder: (_) => SearchConnection());
    case Routes.EXPENSES_ADD :
      return MaterialPageRoute(builder: (_) => ExpenseDetails());
    case Routes.HOUSEHOLD_DETAILS :
      return MaterialPageRoute(builder: (_) => HouseholdDetail());
    case Routes.DASHBOARD :
      return MaterialPageRoute(builder: (_) => Dashboard());
    case Routes.SEARCH_CONSUMER :
      return MaterialPageRoute(builder: (_) => SearchConsumerResult());
    case Routes.BILL_GENERATE :
      return MaterialPageRoute(builder: (_) => GenerateBill());
    default :
      return MaterialPageRoute(builder: (_) => SelectLanguage());
  }
  }