

import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/models.dart';

class ExpensesRepository extends BaseService {

  Future<bool> addExpenses(Map body) async {
    var result = false;
    var res = await makeRequest(
        url: Url.ADD_EXPENSES, body: body, method: RequestType.POST, requestInfo: RequestInfo('mgramseva-common', .01, "", "_search", 1, "", "", ""));

    if (res != null) {
      result = true;
    }
    return result;
  }
}