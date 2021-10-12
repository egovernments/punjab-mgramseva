import 'dart:typed_data';

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

enum DashBoardType { collections, Expenditure }

enum DateType {YTD, MONTH, YEAR, LABEL}

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
  final String Function() label;
  final List<dynamic> result;

  SearchResult(this.label, this.result);
}

class PaginationResponse {
  int offset = 0;
  int limit;
  PaginationResponse(this.limit, this.offset);
}

class TableHeader {
  final String label;
  final ValueChanged<TableHeader>? callBack;
  bool? isSortingRequired = false;
  bool? isAscendingOrder;
  String? apiKey;
  TableHeader(this.label,
      {this.callBack,
      this.isSortingRequired,
      this.isAscendingOrder,
      this.apiKey});
}

class TableDataRow {
  final List<TableData> tableRow;
  TableDataRow(this.tableRow);
}

class TableData {
  final String label;
  final TextStyle? style;
  final String? apiKey;
  ValueChanged<TableData>? callBack;
  TableData(this.label, {this.style, this.callBack, this.apiKey});
}

class SortBy {
  final String key;
  final bool isAscending;
  SortBy(this.key, this.isAscending);
}

class DatePeriod {
  final DateTime startDate;
  final DateTime endDate;
  final DateType dateType;
  final String? label;
  DatePeriod(this.startDate, this.endDate, this.dateType, [this.label]);
}

class Legend {
  final String label;
  final Color color;

  Legend(this.label, this.color);
}


class CustomFile {
  final Uint8List bytes;
  final String name;
  final String extension;

  CustomFile(this.bytes, this.name, this.extension);
}
