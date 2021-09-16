import 'package:mgramseva/model/bill/bill_payments.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/model/common/pdfservice.dart';
import 'package:mgramseva/model/demand/demand_list.dart';
import 'package:mgramseva/model/file/file_store.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

class BillingServiceRepository extends BaseService {
  getRequestInfo(CRITERIA) {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    return RequestInfo(
        APIConstants.API_MODULE_NAME,
        APIConstants.API_VERSION,
        APIConstants.API_TS,
        CRITERIA,
        APIConstants.API_DID,
        APIConstants.API_KEY,
        APIConstants.API_MESSAGE_ID,
        commonProvider.userDetails?.accessToken);
  }

  Future<DemandList> fetchdDemand(Map<String, dynamic> queryparams) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    late DemandList demandList;
    var res = await makeRequest(
        url: Url.FETCH_DEMAND,
        body: {'userInfo': commonProvider.userDetails?.userRequest?.toJson()},
        queryParameters: queryparams,
        requestInfo: getRequestInfo('_search'),
        method: RequestType.POST);
    if (res != null) {
      demandList = DemandList.fromJson({"Demands": res['Demands']});
      (res);
    }
    return demandList;
  }

  Future<BillList> fetchdBill(Map<String, dynamic> queryparams) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    late BillList billList;
    var res = await makeRequest(
        url: Url.FETCH_BILL,
        body: {'userInfo': commonProvider.userDetails?.userRequest?.toJson()},
        queryParameters: queryparams,
        requestInfo: getRequestInfo('_search'),
        method: RequestType.POST);
    if (res != null) {
      billList = BillList.fromJson(res);
    }
    return billList;
  }

  Future<BillList> fetchBillwithoutLogin(
      Map<String, dynamic> queryparams) async {
    late BillList billList;
    var res = await makeRequest(
        url: Url.SEARCH_BILL,
        body: {"RequestInfo": {}},
        queryParameters: queryparams,
        method: RequestType.POST);
    if (res != null) {
      billList = BillList.fromJson(res);
    }
    return billList;
  }

  Future<BillPayments> fetchdBillPayments(
      Map<String, dynamic> queryparams) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    late BillPayments billPaymentList;
    var res = await makeRequest(
        url: Url.FETCH_BILL_PAYMENTS,
        body: {'userInfo': commonProvider.userDetails?.userRequest?.toJson()},
        queryParameters: queryparams,
        requestInfo: getRequestInfo('_search'),
        method: RequestType.POST);
    if (res != null) {
      billPaymentList = BillPayments.fromJson(res);
    }
    return billPaymentList;
  }

  Future<BillPayments> fetchdBillPaymentsNoAuth(
      Map<String, dynamic> queryparams) async {
    late BillPayments billPaymentList;
    var res = await makeRequest(
        url: Url.FETCH_BILL_PAYMENTS,
        body: {"RequestInfo": {}},
        queryParameters: queryparams,
        method: RequestType.POST);
    if (res != null) {
      billPaymentList = BillPayments.fromJson(res);
    }
    return billPaymentList;
  }

  Future<PDFServiceResponse?> fetchdfilestordIDNoAuth(
      body, Map<String, dynamic> params) async {
    late PDFServiceResponse billPaymentpdf;
    var res = await makeRequest(
        url: Url.FETCH_FILESTORE_ID_PDF_SERVICE,
        body: body,
        queryParameters: params,
        requestInfo: RequestInfo(
            APIConstants.API_MODULE_NAME,
            APIConstants.API_VERSION,
            APIConstants.API_TS,
            "_create",
            APIConstants.API_DID,
            APIConstants.API_KEY,
            "string|" + 'en_IN',
            ""),
        method: RequestType.POST);
    if (res != null) {
      billPaymentpdf = PDFServiceResponse.fromJson(res);
    }
    return billPaymentpdf;
  }

  Future<List<FileStore>?> fetchFiles(
      List<String> storeId, String tenantId) async {
    List<FileStore>? fileStoreIds;

    var res = await makeRequest(
        url:
            '${Url.FILE_FETCH}?tenantId=$tenantId&fileStoreIds=${storeId.join(',')}',
        method: RequestType.GET);

    if (res != null) {
      fileStoreIds = res['fileStoreIds']
          .map<FileStore>((e) => FileStore.fromJson(e))
          .toList();
    }
    return fileStoreIds;
  }
}
