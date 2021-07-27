import 'dart:convert';

import 'package:mgramseva/model/userProfile/user_profile.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/global_variables.dart';

import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

class UserProfileRepository extends BaseService {
  Future<UserProfile> getProfile(Map body) async {
    print(navigatorKey.currentContext!);
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    final requestInfo = RequestInfo('ap.public', .01, "", "POST", 1, "", "",
        commonProvider.userDetails!.accessToken);
    late UserProfile userProfile;
    var res = await makeRequest(
        url: UserUrl.USER_PROFILE,
        body: json.encode({"RequestInfo": requestInfo.toJson(), ...body}),
        method: RequestType.POST);
    if (res != null) {
      userProfile = UserProfile.fromJson(res);
      userProfile.user![0].setText();
    }
    return userProfile;
  }
}
