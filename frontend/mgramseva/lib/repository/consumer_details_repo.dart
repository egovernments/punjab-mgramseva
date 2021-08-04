import 'package:mgramseva/model/connection/connection_payment.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/consumer_payment.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
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
        requestInfo: RequestInfo('mgramseva', "", "", "", "", "", "",
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
        requestInfo: RequestInfo('mgramseva-common', .01, "", "_create", 1, "",
            "", commonProvider.userDetails!.accessToken));

    return res;
  }


  Future<ConnectionPayment?> getConsumerPaymentDetails() async {
    ConnectionPayment? connectionPayment;
    // var commonProvider = Provider.of<CommonProvider>(
    //     navigatorKey.currentContext!,
    //     listen: false);
    // var res = await makeRequest(
    //     url: Url.EGOV_LOCATIONS,
    //     queryParameters: body.map((key, value) =>
    //         MapEntry(key, value == null ? null : value.toString())),
    //     method: RequestType.POST,
    //     requestInfo: RequestInfo('mgramseva-common', .01, "", "_create", 1, "",
    //         "", commonProvider.userDetails!.accessToken));

    var res = {
      'connectionId' : 'ESDRD2433',
      'consumerName' : 'eGOV',
      'totalAmount' : 1234,
      'billIdNo' : 'WE2323',
      'billPeriod' : 'Jan 2020 2021',
      'waterCharges' : 1234,
      'arrears' : 400,
      'waterChargesList' : [
        {
          'waterCharge' : 123,
          'date' : 'Feb 2021 2022'
        },

      ],
      'totalDueAmount' : 1234
    };

    if(res != null){
      connectionPayment = ConnectionPayment.fromJson(res);
    }
    return connectionPayment;
  }
  
  Future addconnection(Map body) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    var res = await makeRequest(
        url: Url.ADD_WC_CONNECTION,
        body: {"WaterConnection": body},
        method: RequestType.POST,
        requestInfo: RequestInfo('mgramseva-common', .01, "", "_create", 1, "",
            "", commonProvider.userDetails!.accessToken));
    return res;
  }
}
