

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

    if (res != null) {
      vendorList = res;
    }
    return vendorList;
  }
}