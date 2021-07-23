

import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/models.dart';

class AuthenticationRepository extends BaseService {

  Future<dynamic> validateLogin(Map body, Map<String, String> headers) async {
    late dynamic loginResponse;

    var res = await makeRequest(url: Url.AUTHENTICATE, body: body, headers: headers, method: RequestType.POST);
    if (res != null) {
     loginResponse = res;
    }
    return  loginResponse;
  }
}