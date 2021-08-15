import 'package:mgramseva/model/common/demand.dart';
import 'package:mgramseva/model/common/fetch_bill.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

class ConsumerRepository extends BaseService {
  Future addProperty(Map body) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    var res = await makeRequest(
        url: Url.ADD_PROPERTY,
        body: {"Property": body},
        method: RequestType.POST,
        requestInfo: RequestInfo(APIConstants.API_MODULE_NAME, APIConstants.API_VERSION, APIConstants.API_TS, "", APIConstants.API_DID, APIConstants.API_KEY, APIConstants.API_MESSAGE_ID,
            commonProvider.userDetails!.accessToken));
    return res;
  }

  Future getLocations(Map body) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    var res = await makeRequest(
        url: Url.EGOV_LOCATIONS,
        queryParameters: body.map((key, value) =>
            MapEntry(key, value == null ? null : value.toString())),
        method: RequestType.POST,
        requestInfo: RequestInfo(APIConstants.API_MODULE_NAME, APIConstants.API_VERSION, APIConstants.API_TS, "_create",APIConstants.API_DID, APIConstants.API_KEY, APIConstants.API_MESSAGE_ID, commonProvider.userDetails!.accessToken));
    return res;
  }

  Future addconnection(Map body) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    var res = await makeRequest(
        url: Url.ADD_WC_CONNECTION,
        body: {"WaterConnection": body},
        method: RequestType.POST,
        requestInfo: RequestInfo('mgramseva-common', 1, "", "_create", 1, "",
            "", commonProvider.userDetails!.accessToken));
    return res;
  }

  Future<List<FetchBill>?> getBillDetails(Map<String, dynamic> query) async {
    List<FetchBill>? fetchBill;
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    var body = {
      'userInfo' : commonProvider.userDetails?.userRequest?.toJson()
    };

    var res = await makeRequest(
        url: Url.FETCH_BILL,
        method: RequestType.POST,
        queryParameters: query,
        body: body,
        requestInfo: RequestInfo(APIConstants.API_MODULE_NAME, APIConstants.API_VERSION, APIConstants.API_TS, "", APIConstants.API_DID, APIConstants.API_KEY, APIConstants.API_MESSAGE_ID,
            commonProvider.userDetails!.accessToken));

    if(res != null){
      fetchBill = res['Bill']?.map<FetchBill>((e) => FetchBill.fromJson(e)).toList();
    }
    return fetchBill;
  }

  Future<List<Demand>?> getDemandDetails(Map<String, dynamic> query) async {
    List<Demand>? demand;
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    var body = {
      'userInfo' : commonProvider.userDetails?.userRequest?.toJson()
    };

    var res = await makeRequest(
        url: Url.FETCH_DEMAND,
        method: RequestType.POST,
        body: body,
        queryParameters: query,
        requestInfo: RequestInfo(APIConstants.API_MODULE_NAME, APIConstants.API_VERSION, APIConstants.API_TS, "", APIConstants.API_DID, APIConstants.API_KEY, APIConstants.API_MESSAGE_ID,
            commonProvider.userDetails!.accessToken));

    if(res != null){
      demand = res['Demands']?.map<Demand>((e) => Demand.fromJson(e)).toList();
    }
    return demand;
  }

  Future<List<Map>?> collectPayment(Map body) async {
    List<Map>? response;
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    var res = await makeRequest(
        url: Url.COLLECT_PAYMENT,
        method: RequestType.POST,
        body: body,
        requestInfo: RequestInfo(APIConstants.API_MODULE_NAME, APIConstants.API_VERSION, APIConstants.API_TS, "", APIConstants.API_DID, APIConstants.API_KEY, APIConstants.API_MESSAGE_ID,
            commonProvider.userDetails!.accessToken));

    if(res != null){
      response = res['Payments'];
    }
    return response;
  }
}
