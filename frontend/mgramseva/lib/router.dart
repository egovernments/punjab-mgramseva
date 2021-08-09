import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/ConsumerDetails/ConsumerDetails.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/screeens/Login/Login.dart';
import 'package:mgramseva/screeens/SearchConnection.dart';
import 'package:mgramseva/screeens/SelectLanguage/languageSelection.dart';
import 'package:mgramseva/main.dart';
import 'package:mgramseva/screeens/ChangePassword/Changepassword.dart';
import 'package:mgramseva/screeens/ConnectionResults.dart';
import 'package:mgramseva/screeens/Dashboard.dart';
import 'package:mgramseva/screeens/Profile/EditProfile.dart';
import 'package:mgramseva/screeens/ExpenseDetails.dart';
import 'package:mgramseva/screeens/GenerateBill/GenerateBill.dart';
import 'package:mgramseva/screeens/HouseholdDetail.dart';
import 'package:mgramseva/screeens/ResetPassword/Resetpassword.dart';
import 'package:mgramseva/screeens/Updatepassword.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/widgets/not_available.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart';

import 'model/localization/language.dart';
import 'model/success_handler.dart';
import 'model/user/user_details.dart';
import 'providers/language.dart';
import 'screeens/ForgotPassword/ForgotPassword.dart';
import 'screeens/expense/expense_results.dart';
import 'screeens/expense/search_expense.dart';
import 'widgets/CommonSuccessPage.dart';

class router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!, listen: false);

    Uri uri = Uri.parse(settings.name ?? '');
    Map<String, dynamic>? query = uri.queryParameters;
    String? path = uri.path;

    if(kIsWeb){
     var userDetails = commonProvider.getWebLoginStatus();
     if(userDetails == null && Routes.LOGIN != settings.name) {
       path = Routes.SELECT_LANGUAGE;
     }else if(Routes.LOGIN == settings.name){
       path = Routes.LOGIN;
     }
    }

    /// Here we'll handle all the routing
    currentRoute = settings.name;
    switch (path) {
      case Routes.LANDING_PAGE:
        return MaterialPageRoute(builder: (_) => LandingPage());
      case Routes.LOGIN:
        return MaterialPageRoute(
            builder: (_) => Login(),
            settings: RouteSettings(name: Routes.LOGIN));
      case Routes.SELECT_LANGUAGE:
        return MaterialPageRoute(
            builder: (_) => SelectLanguage(),
            settings: RouteSettings(name: Routes.SELECT_LANGUAGE));
      case Routes.FORGOT_PASSWORD:
        return MaterialPageRoute(
            builder: (_) => ForgotPassword(),
            settings: RouteSettings(name: Routes.FORGOT_PASSWORD));
      case Routes.HOME:
        return MaterialPageRoute(
            builder: (_) => Home(),
            settings: RouteSettings(name: Routes.HOME));
      case Routes.HOUSEHOLD:
        return MaterialPageRoute(
            builder: (_) => SearchConnection(),
            settings: RouteSettings(name: Routes.HOUSEHOLD));
      case Routes.EDIT_PROFILE:
        return MaterialPageRoute(
            builder: (_) => EditProfile(),
            settings: RouteSettings(name: Routes.EDIT_PROFILE));
      case Routes.CHANGE_PASSWORD:
        return MaterialPageRoute(
            builder: (_) => ChangePassword(),
            settings: RouteSettings(name: Routes.CHANGE_PASSWORD));
      case Routes.UPDATE_PASSWORD:
        return MaterialPageRoute(
            builder: (_) => UpdatePassword(),
            settings: RouteSettings(name: Routes.UPDATE_PASSWORD));
      case Routes.CONSUMER_SEARCH:
        return MaterialPageRoute(
            builder: (_) => SearchConnection(),
            settings: RouteSettings(name: Routes.CONSUMER_SEARCH));
      case Routes.EXPENSES_ADD:
        return MaterialPageRoute(
            builder: (_) => ExpenseDetails(),
            settings: RouteSettings(name: Routes.EXPENSES_ADD));
      case Routes.EXPENSE_UPDATE:
         String? id;
        if(settings.arguments != null){
          id = settings.arguments as String;
        }else{
          if(queryValidator(Routes.EXPENSE_UPDATE, query)){
            id = query['id'];
          }else{
            return pageNotAvailable;
          }
        }
        return MaterialPageRoute(
            builder: (_) => ExpenseDetails(id: id),
            settings: RouteSettings(name: '${Routes.EXPENSE_UPDATE}?id=$id'));
      case Routes.HOUSEHOLD_DETAILS:
        return MaterialPageRoute(
            builder: (_) => HouseholdDetail(),
            settings: RouteSettings(name: Routes.HOUSEHOLD_DETAILS));
      case Routes.DASHBOARD:
        return MaterialPageRoute(
            builder: (_) => Dashboard(),
            settings: RouteSettings(name: Routes.DASHBOARD));
      case Routes.SEARCH_CONSUMER:
        return MaterialPageRoute(
            builder: (_) => SearchConsumerResult(),
            settings: RouteSettings(name: Routes.SEARCH_CONSUMER));
      case Routes.BILL_GENERATE:
        return MaterialPageRoute(
            builder: (_) => GenerateBill(),
            settings: RouteSettings(name: Routes.BILL_GENERATE));
      case Routes.CONSUMER_CREATE:
        return MaterialPageRoute(
            builder: (_) => ConsumerDetails(),
            settings: RouteSettings(name: Routes.CONSUMER_CREATE));
      case Routes.SUCCESS_VIEW: case '/home/editProfile/success' :
        String routePath;
        SuccessHandler successHandler;

        if(settings.arguments != null){
          successHandler = settings.arguments as SuccessHandler;
          routePath = '${(settings.arguments as SuccessHandler).routeParentPath}${Routes.SUCCESS_VIEW}?${Uri(queryParameters: successHandler.toJson()).query}';
          query = (settings.arguments as SuccessHandler).toJson();
        }else{
          routePath = settings.name!;
          successHandler = SuccessHandler.fromJson(query);
        }
        return MaterialPageRoute(
            builder: (_) => CommonSuccess(successHandler),
            settings: RouteSettings(name: '$routePath'));
      case Routes.EXPENSE_SEARCH:
        return MaterialPageRoute(
            builder: (_) => SearchExpense(),
            settings: RouteSettings(name: Routes.EXPENSE_SEARCH));
      case Routes.EXPENSE_RESULT:
        if(settings.arguments == null)
          return MaterialPageRoute(
              builder: (_) => SearchExpense(),
              settings: RouteSettings(name: Routes.EXPENSE_SEARCH));
        return MaterialPageRoute(
            builder: (_) => ExpenseResults(searchResult: settings.arguments as SearchResult),
            settings: RouteSettings(name: Routes.EXPENSE_RESULT));

        /// Redirecting routes
      case Routes.RESET_PASSWORD :
        if(settings.arguments == null)
          return MaterialPageRoute(
              builder: (_) => ForgotPassword(),
              settings: RouteSettings(name: Routes.FORGOT_PASSWORD));
        return MaterialPageRoute(
            builder: (_) => ResetPassword(),
            settings: RouteSettings(name: Routes.RESET_PASSWORD));
      default:
        return MaterialPageRoute(
          builder: (_) => SelectLanguage(),
        );
    }
  }


  static bool queryValidator(String route, Map? query){
    if(query == null) return false;

    switch(route){
      case Routes.EXPENSE_UPDATE :
        if(query.keys.contains('id')) return true;
        return false;
      default :
        return false;
    }
  }

  static get pageNotAvailable => MaterialPageRoute(
      builder: (_) => PageNotAvailable(),
    );
}
