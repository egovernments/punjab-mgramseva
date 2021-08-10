import 'package:mgramseva/model/connection/water_connections.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

class SearchConnectionRepository extends BaseService {
  late WaterConnections waterConnections;
  Future<WaterConnections> getconnection(Map<String, dynamic> query) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    var body = {'userInfo': commonProvider.userDetails?.userRequest?.toJson()};

    var res = await makeRequest(
        url: Url.FETCH_WC_CONNECTION,
        body: body,
        queryParameters: query,
        method: RequestType.POST,
        requestInfo: RequestInfo(
          'Rainmaker',
          1,
          "",
          "search",
          "",
          "",
          "",
          commonProvider.userDetails!.accessToken,
        ));

    if (res != null) {
      waterConnections = WaterConnections.fromJson(
          {"waterConnection": res['WaterConnection']});
    }
    return waterConnections;
  }
}
