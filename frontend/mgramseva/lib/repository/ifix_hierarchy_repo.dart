import 'package:provider/provider.dart';
import 'package:mgramseva/services/urls.dart';
import '../model/mdms/department.dart';
import '../providers/common_provider.dart';
import '../services/RequestInfo.dart';
import '../services/base_service.dart';
import '../utils/global_variables.dart';
import '../utils/models.dart';

class IfixHierarchyRepo extends BaseService {
  Future<Department?> fetchDepartments(String code, bool getAncestry,
      [String? token]) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    late Department? departments;
    final requestInfo = RequestInfo('mGramSeva', .01, "", "search", "", "", "",
        token ?? commonProvider.userDetails!.accessToken);
    var body = {
      "criteria": {
        "code": code,
        "tenantId":
            commonProvider.userDetails!.selectedtenant?.code?.substring(0, 2),
        "getAncestry": getAncestry
      },
      'requestHeader': {
        "ts": 1627193067,
        "version": "2.0.0",
        "msgId": "Unknown",
        "signature": "NON"
      }
    };
    var res = await makeRequest(
        url: Url.IFIX_DEPARTMENT_ENTITY,
        body: body,
        requestInfo: requestInfo,
        method: RequestType.POST);
    if (res != null &&
        res['departmentEntity'] != null) {
      try{
        departments = Department.fromJson(res['departmentEntity'][0]);
      }catch(e){
        departments=null;
      }
    }
    return departments;
  }
}
