import 'dart:convert';

import 'package:mgramseva/model/userProfile/user_profile.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/models.dart';

class UserProfileRepository extends BaseService {
  Future<UserProfile> getProfile(Map body) async {
    final requestInfo = RequestInfo('ap.public', .01, "", "POST", 1, "", "",
        "c3f5b1f1-d0fa-46ab-9fdd-ae5cb37f05d5");
    late UserProfile userProfile;
    var res = await makeRequest(
        url: UserUrl.USER_PROFILE,
        body: body,
        requestInfo: requestInfo,
        method: RequestType.POST);
    if (res != null) {
      userProfile = UserProfile.fromJson(res);
      userProfile.user![0].setText();
    }
    return userProfile;
  }
}
