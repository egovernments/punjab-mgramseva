import 'package:mgramseva/model/bill_generation_details/bill_generation_details.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';
import 'package:mgramseva/services/urls.dart';

class BillGenerateRepository extends BaseService {
  Future<BillGenerationDetails> calculateMeterConnection(Map body) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    final requestInfo = RequestInfo(APIConstants.API_MODULE_NAME, APIConstants.API_VERSION, APIConstants.API_TS, "create", APIConstants.API_DID, APIConstants.API_KEY, APIConstants.API_MESSAGE_ID,
        commonProvider.userDetails!.accessToken);
    late BillGenerationDetails billGenerationDetails;
    var res = await makeRequest(
        url: Url.METER_CONNECTION_DEMAND,
        body: body,
        requestInfo: requestInfo,
        method: RequestType.POST);
    if (res != null) {
      billGenerationDetails = BillGenerationDetails.fromJson(res);
    }
    return billGenerationDetails;
  }

  Future<BillGenerationDetails> bulkDemand(Map body) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    final requestInfo = RequestInfo(APIConstants.API_MODULE_NAME, APIConstants.API_VERSION, APIConstants.API_TS, "create", APIConstants.API_DID, APIConstants.API_KEY, APIConstants.API_MESSAGE_ID,
        commonProvider.userDetails!.accessToken);
    late BillGenerationDetails billGenDetails;
    var res = await makeRequest(
        url: Url.BULK_DEMAND,
        body: body,
        requestInfo: requestInfo,
        method: RequestType.POST);
    if (res != null) {
      billGenDetails = BillGenerationDetails.fromJson(res);
    }
    return billGenDetails;
  }
}