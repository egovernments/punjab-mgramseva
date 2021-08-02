import 'package:mgramseva/model/forgotPassword/forgot_password.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/models.dart';

class ForgotPasswordRepository extends BaseService {
  Future<ForgotPasswordOTP> forgotPassword(Map body) async {
    final requestInfo = RequestInfo('Rainmaker', .01, "", "_search", 1, "", "",
        "61894cd3-6628-47f0-a322-c8c2adcf8731");
    late ForgotPasswordOTP forgotPasswordOTP;
    var res = await makeRequest(
        url: UserUrl.OTP_RESET_PASSWORD,
        body: body,
        requestInfo: requestInfo,
        method: RequestType.POST);
    if (res != null) {
      forgotPasswordOTP = ForgotPasswordOTP.fromJson(res);
    }
    return forgotPasswordOTP;
  }
}