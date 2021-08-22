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

enum DashBoardType {collections, Expenditure}

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

class PaginationResponse{
  int offset = 0;
  int limit;
  PaginationResponse(this.limit, this.offset);
}


class TableHeader {
  final String label;

  TableHeader(this.label);
}

class TableDataRow {
  final List<TableData> tableRow;
  TableDataRow(this.tableRow);
}

class TableData {
  final String label;
  final TextStyle? style;
  TableData(this.label, {this.style});
}
