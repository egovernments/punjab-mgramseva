

import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/model/expensesDetails/vendor.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

class ExpensesRepository extends BaseService {

  Future<Map> addExpenses(Map body) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    var res = await makeRequest(
        url: Url.ADD_EXPENSES, body: body, method: RequestType.POST, requestInfo: RequestInfo('Rainmaker', .01, "", "create", "", "", "",
        commonProvider.userDetails!.accessToken));
    return res;
  }


  Future<List<Vendor>?> getVendor(Map<String, dynamic> query) async {
     List<Vendor>? vendorList;
     var commonProvider = Provider.of<CommonProvider>(
         navigatorKey.currentContext!,
         listen: false);

     var body = {
       'userInfo' : commonProvider.userDetails?.userRequest?.toJson()
     };

    var res = await makeRequest(
        url: Url.VENDOR_SEARCH, body: body, queryParameters: query, method: RequestType.POST, requestInfo: RequestInfo('Rainmaker', .01, "", "create", "", "", "",
        commonProvider.userDetails!.accessToken, ));

    if (res != null && res['vendor'] != null) {
      vendorList = res['vendor'].map<Vendor>((e) => Vendor.fromJson(e)).toList();
    }
    return vendorList;
  }

  Future<List<ExpensesDetailsModel>?> searchExpense(Map<String, dynamic> query) async {
    List<ExpensesDetailsModel>? expenseResult;
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    // var res = await makeRequest(
    //     url: Url.VENDOR_SEARCH, body: body, queryParameters: query, method: RequestType.POST, requestInfo: RequestInfo('Rainmaker', .01, "", "create", "", "", "",
    //   commonProvider.userDetails!.accessToken, ));

    var res = {
      'expense' : [
        {
          'vendor': 'dsfds',
          'billId': 'ewrew3',
          'typeOfExpense': 'ewrew',
          'billDate': 1628070747868,
          'amount': [ {
            'amount': '123'
          }],
          'status': 'unpaid'
        },
        {
          'vendor': 'dsfds',
          'billId': 'ewrew3',
          'typeOfExpense': 'ewrew',
          'billDate': 1628070747868,
          'amount': [ {
            'amount': '123'
          }],
          'status': 'unpaid'
        }
      ]
    };

    if (res != null) {
      expenseResult = res['expense']?.map<ExpensesDetailsModel>((e) => ExpensesDetailsModel.fromJson(e)).toList();
    }
    return expenseResult;
  }
}