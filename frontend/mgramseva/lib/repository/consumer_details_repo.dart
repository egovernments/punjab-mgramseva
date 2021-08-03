import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/consumer_payment.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

class ConsumerRepository extends BaseService {
  Future<bool> addProperty(Map body) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    var result = false;
    var res = await makeRequest(
        url: Url.ADD_PROPERTY,
        body: body,
        method: RequestType.POST,
        requestInfo: RequestInfo('mgramseva-common', .01, "", "_create", 1, "",
            "", commonProvider.userDetails!.accessToken));

    if (res != null) {
      result = true;
    }
    return result;
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

  Future<ConsumerPayment?> getConsumerPaymentDetails() async {
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

    // var res = {
    //
    // };
    //
    // return res;
  }
}
