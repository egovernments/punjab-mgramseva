

import 'package:mgramseva/model/user/user_details.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/models.dart';

class AuthenticationRepository extends BaseService {

  Future<UserDetails> validateLogin(Map body, Map<String, String> headers) async {
    late UserDetails loginResponse;

    var res = await makeRequest(url: UserUrl.AUTHENTICATE, body: body, headers: headers, method: RequestType.POST);
    if (res != null) {
     loginResponse = UserDetails.fromJson(res);
    }
    return  loginResponse;
  }
}