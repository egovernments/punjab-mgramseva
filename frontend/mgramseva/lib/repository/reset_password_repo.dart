import 'package:mgramseva/model/resetPassword/reset_password.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/models.dart';

class ResetPasswordRepository extends BaseService {
  Future<ResetPasswordDetails> forgotPassword(Map body) async {
    print("repo---->");
    print(body);
    final requestInfo = RequestInfo('Rainmaker', .01, "", "create", 1, "", "",
        "61894cd3-6628-47f0-a322-c8c2adcf8731");
    late ResetPasswordDetails resetPasswordDetails;
    var res = await makeRequest(
        url: UserUrl.RESET_PASSWORD,
        body: body,
        requestInfo: requestInfo,
        method: RequestType.POST);
    if (res != null) {
      resetPasswordDetails = ResetPasswordDetails.fromJson(res);
    }
    return resetPasswordDetails;
  }
}