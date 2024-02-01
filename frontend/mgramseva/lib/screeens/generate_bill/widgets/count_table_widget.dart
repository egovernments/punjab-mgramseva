import 'package:flutter/material.dart';
import 'package:mgramseva/model/reports/WaterConnectionCount.dart';
import 'package:mgramseva/utils/constants/i18_key_constants.dart';
import '../../../utils/date_formats.dart';
import '../../../utils/localization/application_localizations.dart';

class CountTableWidget extends StatefulWidget {
  final List<WaterConnectionCount>? waterConnectionCount;

  const CountTableWidget({Key? key, this.waterConnectionCount})
      : super(key: key);

  @override
  _CountTableWidgetState createState() => _CountTableWidgetState();
}

class _CountTableWidgetState extends State<CountTableWidget> {
  bool _isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    final List<WaterConnectionCount>? connectionCount =
        widget.waterConnectionCount;

    return Container(
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth <= 760) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    child: _buildDataTable(connectionCount!),
                  ),
                );
              } else {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    child: _buildDataTable(connectionCount!));
              }
            },
          ),
          if (connectionCount!.length >= 5)
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isCollapsed = !_isCollapsed;
                  });
                },
                child: Text(_isCollapsed
                    ? "${ApplicationLocalizations.of(context).translate(i18.common.VIEW_ALL)}"
                    : "${ApplicationLocalizations.of(context).translate(i18.common.COLLAPSE)}"),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDataTable(List<WaterConnectionCount> connectionCount) {
    return DataTable(
      border: TableBorder.all(
          width: 0.5, borderRadius: BorderRadius.all(Radius.circular(5))),
      columns: [
        DataColumn(
            label: FittedBox(
                child: Text(
                    "${ApplicationLocalizations.of(context).translate(i18.common.LAST_BILL_CYCLE_MONTH)}"))),
        DataColumn(
            label: FittedBox(
                child: Text(
                    "${ApplicationLocalizations.of(context).translate(i18.common.CONSUMER_COUNT)}")))
      ],
      rows: _isCollapsed
          ? connectionCount.take(5).map((e) => _buildDataRow(e)).toList()
          : connectionCount.map((e) => _buildDataRow(e)).toList(),
    );
  }

  DataRow _buildDataRow(WaterConnectionCount count) {
    return DataRow(
      cells: [
        DataCell(Text(DateFormats.getMonthAndYearFromDateTime(
            DateTime.fromMillisecondsSinceEpoch(count.taxperiodto!)))),
        DataCell(Text(count.count.toString())),
      ],
    );
  }
}
