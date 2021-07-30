
import 'package:flutter/material.dart';

enum RequestType { GET, PUT, POST, DELETE }

enum ExceptionType {UNAUTHORIZED, BADREQUEST, INVALIDINPUT, FETCHDATA}

enum MDMSType {BusinessService, ConsumerType, TaxHeadCode}

class KeyValue {
  String label;
  dynamic key;
  KeyValue(this.label, this.key);
}

class HomeItem {
  final String label;
  final IconData iconData;
  final String link;

  const HomeItem(this.label, this.iconData, this.link);
}
