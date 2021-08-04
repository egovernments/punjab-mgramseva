import 'package:mgramseva/model/resetPassword/reset_password.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

class ResetPasswordRepository extends BaseService {
  Future<ResetPasswordDetails> forgotPassword(Map body) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    final requestInfo = RequestInfo('Rainmaker', .01, "", "create", 1, "", "",
        commonProvider.userDetails!.accessToken);
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