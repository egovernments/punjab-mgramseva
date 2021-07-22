import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:mgramseva/app_config.dart';
import 'package:mgramseva/utils/models.dart';

class BaseService{

  Future<dynamic> makeRequest<T>({
    @required String? url,
    String? baseUrl,
    dynamic body,
    String? contentType,
    Map<String, dynamic>? queryParameters,
    RequestType method = RequestType.GET,
  }) async {
    var uri;

    if(queryParameters == null) {
      uri = Uri.parse('$apiBaseUrl$url');
    }else{
     uri = Uri.https(apiBaseUrl, url!,  queryParameters);
    }


    // dio.options.baseUrl = baseUrl ?? Urls.baseUrl;
    // dio.options.connectTimeout = Constants.CONNECTION_TIMEOUT; //5s
    // dio.options.receiveTimeout = Constants.RECEIVE_TIMEOUT; //5s
    // dio.options.contentType =  'application/json';
    // dio.options.headers =  {
    //   "Connection" : 'Keep-Alive'
    // };
    http.Response response;
    switch (method) {
      case RequestType.GET:
          response = await http.get(uri);
          return json.decode(
              utf8.decode(response.bodyBytes));
        break;
      case RequestType.PUT:
        response =
        await http.put(uri, body : json.encode(body));
        return json.decode(
            utf8.decode(response.bodyBytes));
        break;
      case RequestType.POST:
        response =
        await http.post(uri,
            body : json.encode(body));
        return json.decode(
            utf8.decode(response.bodyBytes));
        break;
      case RequestType.DELETE:
        response =
        await http.delete(uri,
             body : json.encode(body));
        return json.decode(
            utf8.decode(response.bodyBytes));
    }
  }

}