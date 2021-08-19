import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:mgramseva/Env/app_config.dart';
import 'package:mgramseva/model/file/file_store.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/localization/localization_label.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CoreRepository extends BaseService {
  Future<List<LocalizationLabel>> getLocilisation(
      Map<String, dynamic> query) async {
    late List<LocalizationLabel> labelList;
    var res = await makeRequest(
        url: Url.LOCALIZATION,
        queryParameters: query,
        requestInfo: RequestInfo(APIConstants.API_MODULE_NAME, APIConstants.API_VERSION, APIConstants.API_TS, "_search", APIConstants.API_DID, APIConstants.API_KEY, APIConstants.API_MESSAGE_ID, ""),
        method: RequestType.POST);
    if (res != null) {
      labelList = res['messages']
          .map<LocalizationLabel>((e) => LocalizationLabel.fromJson(e))
          .toList();
    }
    return labelList;
  }

  Future<LanguageList> getMdms(Map body) async {
    late LanguageList languageList;
    var res = await makeRequest(
        url: Url.MDMS, body: body, method: RequestType.POST, requestInfo: RequestInfo(APIConstants.API_MODULE_NAME, APIConstants.API_VERSION, APIConstants.API_TS, "_search", APIConstants.API_DID, APIConstants.API_KEY, APIConstants.API_MESSAGE_ID, ""));
    if (res != null) {
      languageList = LanguageList.fromJson(res);
    }
    return languageList;
  }

  Future<List<FileStore>> uploadFiles(List<PlatformFile>? _paths, String moduleName) async {
    Map? respStr;
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    var postUri = Uri.parse("$apiBaseUrl${Url.FILE_UPLOAD}");
    var request = new http.MultipartRequest("POST", postUri);
    if(_paths != null && _paths.isNotEmpty) {
      for(var i = 0; i < _paths.length; i++) {
        var path = _paths[i];
        http.MultipartFile multipartFile = http.MultipartFile.fromBytes('file', path.bytes!, filename: '${path.name}.${path.extension}');
        request.files.add(multipartFile);
      }
      request.fields['tenantId'] = commonProvider.userDetails!.selectedtenant!.code!;
      request.fields['module'] = moduleName;
    }
    await request.send().then((response) async{
      if (response.statusCode == 201)
      respStr = json.decode(await response.stream.bytesToString());
    });
    if(respStr?['fileStoreIds'] != null) {
      return respStr?['fileStoreIds']
          .map<FileStore>((e) => FileStore.fromJson(e))
          .toList();
    }
    return <FileStore>[];
  }


  Future<List<FileStore>?> fetchFiles(List<String> storeId) async {
     List<FileStore>? fileStoreIds;

    var res = await makeRequest(
        url: '${Url.FILE_FETCH}?tenantId=pb&fileStoreIds=${storeId.join(',')}', method: RequestType.GET);

    if (res != null) {
      fileStoreIds = res['fileStoreIds']
          .map<FileStore>((e) => FileStore.fromJson(e))
          .toList();
    }
    return fileStoreIds;
  }
}
