
import 'package:flutter/material.dart';

enum RequestType { GET, PUT, POST, DELETE }

enum ExceptionType {UNAUTHORIZED, BADREQUEST, INVALIDINPUT, FETCHDATA}

class KeyValue {
  String label;
  String key;
  KeyValue(this.label, this.key);
}

class HomeItem {
  final String label;
  final IconData iconData;
  final String link;

  const HomeItem(this.label, this.iconData, this.link);
}
