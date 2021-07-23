import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:mgramseva/app_config.dart';
import 'package:mgramseva/utils/custom_exception.dart';
import 'package:mgramseva/utils/models.dart';

class BaseService{

  Future<dynamic> makeRequest<T>({
    @required String? url,
    String? baseUrl,
    dynamic body,
    String? contentType,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    RequestType method = RequestType.GET,
  }) async {
    var uri;

    if(queryParameters == null) {
      uri = Uri.parse('${baseUrl != null ? baseUrl : apiBaseUrl}$url');
    }else{
      String queryString = Uri(queryParameters: queryParameters).query;
      uri = Uri.parse('${baseUrl != null ? baseUrl : apiBaseUrl}$url?$queryString');
      // uri = Uri.https(apiBaseUrl, url!,  queryParameters);
    }


    // dio.options.baseUrl = baseUrl ?? Urls.baseUrl;
    // dio.options.connectTimeout = Constants.CONNECTION_TIMEOUT; //5s
    // dio.options.receiveTimeout = Constants.RECEIVE_TIMEOUT; //5s
    // dio.options.contentType =  'application/json';
    // dio.options.headers =  {
    //   "Connection" : 'Keep-Alive'
    // };

    var header = headers ??  {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    http.Response response;
    switch (method) {
      case RequestType.GET:
          response = await http.get(uri);
        break;
      case RequestType.PUT:
        response =
        await http.put(uri, body : json.encode(body));
        break;
      case RequestType.POST:
        response =
        await http.post(uri,
            headers: header,
            body : body);
        break;
      case RequestType.DELETE:
        response =
        await http.delete(uri,
             body : json.encode(body));
    }
    return _response(response);
  }

}

dynamic _response(http.Response response) {
  switch (response.statusCode) {
    case 200:
      return json.decode(
          utf8.decode(response.bodyBytes));
      break;
    case 400:
      CustomException('', response.statusCode, ExceptionType.FETCHDATA);
      break;
    case 401:
    case 403:
    CustomException('', response.statusCode, ExceptionType.UNAUTHORIZED);
    break;
    case 500:
    default:
    CustomException('', response.statusCode, ExceptionType.INVALIDINPUT);
  }
}