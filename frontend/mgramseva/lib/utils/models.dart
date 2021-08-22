import 'package:flutter/material.dart';

enum RequestType { GET, PUT, POST, DELETE }

enum ExceptionType {
  UNAUTHORIZED,
  BADREQUEST,
  INVALIDINPUT,
  FETCHDATA,
  OTHER,
  CONNECTIONISSUE
}

enum MDMSType { BusinessService, ConsumerType, TaxHeadCode }

class KeyValue {
  String label;
  dynamic key;
  KeyValue(this.label, this.key);
}

class HomeItem {
  final String label;
  final String walkThroughMsg;
  final IconData iconData;
  final String link;
  final Map<String, dynamic> arguments;

  const HomeItem(
    this.label,
      this.walkThroughMsg,
    this.iconData,
    this.link,
    this.arguments,
  );
}

class SearchResult {
  final String label;
  final List<dynamic> result;

  SearchResult(this.label, this.result);
}
