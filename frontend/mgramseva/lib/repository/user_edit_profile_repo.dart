import 'package:mgramseva/model/userEditProfile/user_edit_profile.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

class UserEditProfileRepository extends BaseService {
  Future<EditUser> editProfile(Map body) async {
    print("repobody--->");
    print(body);
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    final requestInfo = RequestInfo('Rainmaker', .01, "", "create", "", "", "",
        commonProvider.userDetails!.accessToken);
    late EditUser userEditProfile;
    var res = await makeRequest(
        url: UserUrl.EDIT_PROFILE,
        body: body,
        requestInfo: requestInfo,
        method: RequestType.POST);
    if (res != null) {
      userEditProfile = EditUser.fromJson(res);
    }
    return userEditProfile;
  }

}