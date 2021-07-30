import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/models.dart';

class ConsumerRepository extends BaseService {
  Future<bool> addProperty(Map body) async {
    var result = false;
    var res = await makeRequest(
        url: Url.ADD_PROPERTY,
        body: body,
        method: RequestType.POST,
        requestInfo:
            RequestInfo('mgramseva-common', .01, "", "_create", 1, "", "", ""));

    if (res != null) {
      result = true;
    }
    return result;
  }
}
