import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/ConsumerDetails/ConsumerDetails.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/screeens/Login/Login.dart';
import 'package:mgramseva/screeens/ConnectionResults/SearchConnection.dart';
import 'package:mgramseva/screeens/SelectLanguage/languageSelection.dart';
import 'package:mgramseva/main.dart';
import 'package:mgramseva/screeens/ChangePassword/Changepassword.dart';
import 'package:mgramseva/screeens/ConnectionResults.dart';
import 'package:mgramseva/screeens/Profile/EditProfile.dart';
import 'package:mgramseva/screeens/AddExpense/ExpenseDetails.dart';
import 'package:mgramseva/screeens/GenerateBill/GenerateBill.dart';
import 'package:mgramseva/screeens/HouseholdDetail.dart';
import 'package:mgramseva/screeens/ResetPassword/Resetpassword.dart';
import 'package:mgramseva/screeens/Updatepassword.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/role_actions.dart';
import 'package:mgramseva/widgets/not_available.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart';
import 'model/success_handler.dart';

import 'model/user/user_details.dart';
import 'screeens/ForgotPassword/ForgotPassword.dart';
import 'screeens/common/collect_payment.dart';
import 'screeens/dashboard/Dashboard.dart';
import 'screeens/expense/expense_results.dart';
import 'screeens/expense/search_expense.dart';
import 'widgets/CommonSuccessPage.dart';

class router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    Uri uri = Uri.parse(settings.name ?? '');
    Map<String, dynamic>? query = uri.queryParameters;
    String? path = uri.path;
    if (kIsWeb) {
      var userDetails = commonProvider.getWebLoginStatus();
      if (userDetails == null &&
          Routes.LOGIN != settings.name &&
          Routes.FORGOT_PASSWORD != settings.name &&
          Routes.RESET_PASSWORD != settings.name) {
        path = Routes.SELECT_LANGUAGE;
      } else if (Routes.LOGIN == settings.name ||
          Routes.FORGOT_PASSWORD == settings.name ||
          Routes.RESET_PASSWORD == settings.name) {
        path = settings.name;
      }
    }
    if (!(path != null && RoleActionsFiltering().isEligibleRoletoRoute(path)))
      return pageNotAvailable;

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
            builder: (_) => Home(), settings: RouteSettings(name: Routes.HOME));
      case Routes.HOUSEHOLD:
        return MaterialPageRoute(
            builder: (_) => SearchConsumerConnection(settings.arguments as Map),
            settings: RouteSettings(name: Routes.HOUSEHOLD));

      case Routes.HOUSEHOLDRECEIPTS:
        return MaterialPageRoute(
            builder: (_) => SearchConsumerConnection(settings.arguments as Map),
            settings: RouteSettings(name: Routes.HOUSEHOLDRECEIPTS));

      case Routes.CONSUMER_SEARCH_UPDATE:
        return MaterialPageRoute(
            builder: (_) => SearchConsumerConnection(settings.arguments as Map),
            settings: RouteSettings(name: Routes.CONSUMER_SEARCH_UPDATE));

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
            builder: (_) =>
                UpdatePassword(userDetails: settings.arguments as UserDetails),
            settings: RouteSettings(name: Routes.UPDATE_PASSWORD));
      case Routes.CONSUMER_SEARCH:
        return MaterialPageRoute(
            builder: (_) => SearchConsumerConnection(settings.arguments as Map),
            settings: RouteSettings(name: Routes.CONSUMER_SEARCH));

      /// Consumer Update
      case Routes.CONSUMER_UPDATE:
        String? id;
        if (settings.arguments != null) {
          id = ((settings.arguments as Map)['waterconnections']
                  as WaterConnection)
              .connectionNo;
        } else {
          if (queryValidator(Routes.CONSUMER_UPDATE, query)) {
            id = query['applicationNo'];
          } else {
            return pageNotAvailable;
          }
        }
        return MaterialPageRoute(
            builder: (_) => ConsumerDetails(
                id: id,
                waterconnection: settings.arguments != null
                    ? (settings.arguments as Map)['waterconnections']
                        as WaterConnection
                    : null),
            settings: RouteSettings(
                name: '${Routes.CONSUMER_UPDATE}?applicationNo=$id'));

      ///Add Expenses
      case Routes.EXPENSES_ADD:
        return MaterialPageRoute(
            builder: (_) => ExpenseDetails(),
            settings: RouteSettings(name: Routes.EXPENSES_ADD));
      case Routes.EXPENSE_UPDATE:
        String? id;
        if (settings.arguments != null) {
          id = (settings.arguments as ExpensesDetailsModel).challanNo;
        } else {
          if (queryValidator(Routes.EXPENSE_UPDATE, query)) {
            id = query['challanNo'];
          } else {
            return pageNotAvailable;
          }
        }
        return MaterialPageRoute(
            builder: (_) => ExpenseDetails(
                id: id,
                expensesDetails: settings.arguments != null
                    ? settings.arguments as ExpensesDetailsModel
                    : null),
            settings:
                RouteSettings(name: '${Routes.EXPENSE_UPDATE}?challanNo=$id'));

      ///View HosueHold Details
      case Routes.HOUSEHOLD_DETAILS:
        String? id;
        String? mode;
        if (settings.arguments != null) {
          print(settings.arguments);
          id = ((settings.arguments as Map)['waterconnections']
                  as WaterConnection)
              .connectionNo;
          mode = (settings.arguments as Map)['mode'];
        } else {
          if (queryValidator(Routes.HOUSEHOLD_DETAILS, query)) {
            id = query['applicationNo'];
            mode = query['mode'];
          } else {
            return pageNotAvailable;
          }
        }
        return MaterialPageRoute(
            builder: (_) => HouseholdDetail(
                id: id,
                mode: mode,
                waterconnection: settings.arguments != null
                    ? (settings.arguments as Map)['waterconnections']
                        as WaterConnection
                    : null),
            settings: RouteSettings(
                name:
                    '${Routes.HOUSEHOLD_DETAILS}?applicationNo=$id& mode=$mode'));

      case Routes.DASHBOARD:
        return MaterialPageRoute(
            builder: (_) => Dashboard(),
            settings: RouteSettings(name: Routes.DASHBOARD));
      case Routes.SEARCH_CONSUMER_RESULT:
        if (settings.arguments == null) {
          return MaterialPageRoute(
              builder: (_) =>
                  SearchConsumerConnection(settings.arguments as Map),
              settings: RouteSettings(name: Routes.CONSUMER_SEARCH));
        }
        return MaterialPageRoute(
            builder: (_) => SearchConsumerResult(settings.arguments as Map),
            settings: RouteSettings(
              name: '${Routes.SEARCH_CONSUMER_RESULT}',
            ));
      case Routes.BILL_GENERATE:
        String? id;
        if (settings.arguments != null) {
          id = (settings.arguments as WaterConnection)
              .connectionNo!
              .split('/')
              .join("_");
        } else {
          if (queryValidator(Routes.BILL_GENERATE, query)) {
            id = query['applicationNo'];
          } else {
            return pageNotAvailable;
          }
        }
        return MaterialPageRoute(
            builder: (_) => GenerateBill(
                id: id,
                waterconnection: settings.arguments != null
                    ? settings.arguments as WaterConnection
                    : null),
            settings: RouteSettings(
                name: '${Routes.BILL_GENERATE}?applicationNo=$id'));
      case Routes.CONSUMER_CREATE:
        return MaterialPageRoute(
            builder: (_) => ConsumerDetails(),
            settings: RouteSettings(name: Routes.CONSUMER_CREATE));
      case Routes.SUCCESS_VIEW:
      case Routes.EDIT_PROFILE_SUCCESS:
      case Routes.CHANGE_PASSWORD_SUCCESS:
      case Routes.EXPENSES_ADD_SUCCESS:
      case Routes.HOUSEHOLD_DETAILS_SUCCESS:
        String routePath;
        SuccessHandler successHandler;

        if (settings.arguments != null) {
          successHandler = settings.arguments as SuccessHandler;
          routePath =
              '${(settings.arguments as SuccessHandler).routeParentPath}?${Uri(queryParameters: successHandler.toJson()).query}';
          query = (settings.arguments as SuccessHandler).toJson();
        } else {
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
        if (settings.arguments == null)
          return MaterialPageRoute(
              builder: (_) => SearchExpense(),
              settings: RouteSettings(name: Routes.EXPENSE_SEARCH));
        return MaterialPageRoute(
            builder: (_) => ExpenseResults(
                searchResult: settings.arguments as SearchResult),
            settings: RouteSettings(name: Routes.EXPENSE_RESULT));
      case Routes.HOUSEHOLD_DETAILS_COLLECT_PAYMENT:
        late Map<String, dynamic> localQuery;
        if (settings.arguments == null) {
          if (queryValidator(Routes.HOUSEHOLD_DETAILS_COLLECT_PAYMENT, query)) {
            localQuery = query;
          } else {
            return pageNotAvailable;
          }
        } else {
          localQuery = settings.arguments as Map<String, dynamic>;
        }
        return MaterialPageRoute(
            builder: (_) => ConnectionPaymentView(query: localQuery),
            settings: RouteSettings(
                name:
                    '${Routes.HOUSEHOLD_DETAILS_COLLECT_PAYMENT}?${Uri(queryParameters: localQuery).query}'));

      case Routes.RESET_PASSWORD:
        String? id;
        if (settings.arguments != null) {
          id = (settings.arguments as Map)['id'];
        } else {
          return pageNotAvailable;
        }
        if (settings.arguments == null)
          return MaterialPageRoute(
              builder: (_) => ForgotPassword(),
              settings: RouteSettings(name: Routes.FORGOT_PASSWORD));
        return MaterialPageRoute(
            builder: (_) => ResetPassword(
                  id: id,
                ),
            settings:
                RouteSettings(name: '${Routes.RESET_PASSWORD}?mobileNo=$id'));
      case Routes.MANUAL_BILL_GENERATE:
        return MaterialPageRoute(
            builder: (_) => GenerateBill(),
            settings: RouteSettings(name: Routes.MANUAL_BILL_GENERATE));
      default:
        return MaterialPageRoute(
          builder: (_) => SelectLanguage(),
        );
    }
  }

  static bool queryValidator(String route, Map? query) {
    if (query == null) return false;

    switch (route) {
      case Routes.EXPENSE_UPDATE:
        if (query.keys.contains('challanNo')) return true;
        return false;
      case Routes.HOUSEHOLD_DETAILS:
        if (query.keys.contains('applicationNo') && query.keys.contains('mode'))
          return true;
        return false;
      case Routes.HOUSEHOLD_DETAILS_COLLECT_PAYMENT:
        if (query.keys.contains('consumerCode') &&
            query.keys.contains('businessService') &&
            query.keys.contains('tenantId')) return true;
        return false;

      case Routes.BILL_GENERATE:
        if (query.keys.contains('applicationNo')) return true;
        return false;

      default:
        return false;
    }
  }

  static get pageNotAvailable => MaterialPageRoute(
        builder: (_) => PageNotAvailable(),
      );
}
