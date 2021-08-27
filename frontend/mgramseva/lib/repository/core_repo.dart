import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mgramseva/Env/app_config.dart';
import 'package:mgramseva/model/common/pdfservice.dart';
import 'package:mgramseva/model/file/file_store.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/localization/localization_label.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

class CoreRepository extends BaseService {
  Future<List<LocalizationLabel>> getLocilisation(
      Map<String, dynamic> query) async {
    late List<LocalizationLabel> labelList;
    var res = await makeRequest(
        url: Url.LOCALIZATION,
        queryParameters: query,
        requestInfo: RequestInfo(
            APIConstants.API_MODULE_NAME,
            APIConstants.API_VERSION,
            APIConstants.API_TS,
            "_search",
            APIConstants.API_DID,
            APIConstants.API_KEY,
            APIConstants.API_MESSAGE_ID,
            ""),
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
        url: Url.MDMS,
        body: body,
        method: RequestType.POST,
        requestInfo: RequestInfo(
            APIConstants.API_MODULE_NAME,
            APIConstants.API_VERSION,
            APIConstants.API_TS,
            "_search",
            APIConstants.API_DID,
            APIConstants.API_KEY,
            APIConstants.API_MESSAGE_ID,
            ""));
    if (res != null) {
      languageList = LanguageList.fromJson(res);
    }
    return languageList;
  }

  Future<List<FileStore>> uploadFiles(
      List<dynamic>? _paths, String moduleName) async {
    Map? respStr;
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    var postUri = Uri.parse("$apiBaseUrl${Url.FILE_UPLOAD}");
    var request = new http.MultipartRequest("POST", postUri);
    if (_paths != null && _paths.isNotEmpty) {
      if (_paths is List<PlatformFile>) {
        for (var i = 0; i < _paths.length; i++) {
          var path = _paths[i];
          http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
              'file', path.bytes!,
              filename: '${path.name}.${path.extension}');
          request.files.add(multipartFile);
        }
      } else if (_paths is List<File>) {
        _paths.forEach((file) async {
          request.files.add(await http.MultipartFile.fromPath(
              'file', file.path ?? '',
              filename: '${file.path.split('/').last}'));
        });
      }
      request.fields['tenantId'] =
          commonProvider.userDetails!.selectedtenant!.code!;
      request.fields['module'] = moduleName;
      await request.send().then((response) async {
        if (response.statusCode == 201)
          respStr = json.decode(await response.stream.bytesToString());
      });
      if (respStr != null && respStr?['files'] != null) {
        return respStr?['files']
            .map<FileStore>((e) => FileStore.fromJson(e))
            .toList();
      }
    }
    return <FileStore>[];
  }

  Future<List<FileStore>?> fetchFiles(List<String> storeId) async {
    List<FileStore>? fileStoreIds;
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    var res = await makeRequest(
        url:
            '${Url.FILE_FETCH}?tenantId=${commonProvider.userDetails!.selectedtenant!.code!}&fileStoreIds=${storeId.join(',')}',
        method: RequestType.GET);

    if (res != null) {
      fileStoreIds = res['fileStoreIds']
          .map<FileStore>((e) => FileStore.fromJson(e))
          .toList();
    }
    return fileStoreIds;
  }

  Future<String?> urlShotner(String inputUrl) async {
    try {
      var res = await makeRequest(
          url: '${Url.URL_SHORTNER}',
          body: {"url": inputUrl},
          method: RequestType.POST);

      if (res != null) {
        return res;
      }
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e);
    }
  }

  Future<PDFServiceResponse?> getFileStorefromPdfService(body, params) async {
    PDFServiceResponse? pdfServiceResponse;
    try {
      var res = await makeRequest(
          url: '${Url.FETCH_FILESTORE_ID_PDF_SERVICE}',
          body: body,
          queryParameters: params,
          method: RequestType.POST);

      if (res != null) {
        pdfServiceResponse = PDFServiceResponse.fromJson(res);
        return pdfServiceResponse;
      }
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e);
    }
  }

  Future<bool?> fileDownload(BuildContext context, String url,
      [String? fileName]) async {
    fileName = fileName ?? CommonMethods.getExtension(url);
    try {
      var downloadPath;
      if (kIsWeb) {
        html.AnchorElement anchorElement = new html.AnchorElement(href: url);
        anchorElement.download = url;
        anchorElement.click();
        return true;
      } else if (Platform.isIOS) {
        downloadPath = (await getApplicationDocumentsDirectory()).path;
      } else {
        downloadPath = (await getExternalStorageDirectory())?.path;
      }
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      final response = await FlutterDownloader.enqueue(
        url: url,
        savedDir: downloadPath,
        fileName: '$fileName',
        showNotification: true,
        openFileFromNotification: true,
      );
      if (response != null) {
        return true;
      }
      return false;
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(context, e);
    }
  }
}
