import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:provider/provider.dart';

import '../model/reports/bill_report_data.dart';
import '../providers/common_provider.dart';
import '../services/request_info.dart';
import '../utils/global_variables.dart';
import '../utils/models.dart';

class ReportsRepo extends BaseService{
  Future<List<BillReportData>?> fetchBillReport(Map<String,dynamic> params,
      [String? token]) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    List<BillReportData>? billreports;
    final requestInfo = RequestInfo(
        APIConstants.API_MODULE_NAME,
        APIConstants.API_VERSION,
        APIConstants.API_TS,
        '_get',
        APIConstants.API_DID,
        APIConstants.API_KEY,
        APIConstants.API_MESSAGE_ID,
        commonProvider.userDetails?.accessToken,
        commonProvider.userDetails?.userRequest?.toJson());

    var res = await makeRequest(
        url: Url.BILL_REPORT,
        baseUrl: 'http://localhost:8989/',
        queryParameters: params,
        requestInfo: requestInfo,
        method: RequestType.POST);
    if (res != null && res['BillReportData'] != null) {
      try {
        billreports = [];
        res['BillReportData'].forEach((val){
          billreports?.add(BillReportData.fromJson(val));
        });
      } catch (e) {
        billreports = null;
      }
    }
    return billreports;
  }
}