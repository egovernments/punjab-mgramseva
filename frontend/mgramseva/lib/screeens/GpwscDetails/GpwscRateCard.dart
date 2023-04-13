import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import '../../utils/Locilization/application_localizations.dart';
import '../../widgets/LabelText.dart';
import 'GpwscCard.dart';

class GpwscRateCard extends StatelessWidget {
  final String rateType;

  const GpwscRateCard({Key? key, required this.rateType}) : super(key: key);

  Color getColor(Set<MaterialState> states) {
    return Colors.grey.shade200;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width =
          constraints.maxWidth < 760 ? 145 : (constraints.maxWidth / 5);
      return GpwscCard(
        children: [
          Row(
            children: [
              LabelText(
                  "${ApplicationLocalizations.of(context).translate(i18.dashboard.GPWSC_RATE_INFO)}"),
              Text(
                "(${ApplicationLocalizations.of(context).translate(rateType)})",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          _getRateCard(rateType, context, constraints)
        ],
      );
    });
  }

  Widget _getRateCard(String type, context, BoxConstraints constraints) {
    if (type.compareTo("Metered") == 0) {
      return Padding(
        padding: constraints.maxWidth > 760
            ? const EdgeInsets.all(20.0)
            : const EdgeInsets.all(8.0),
        child: DataTable(
            border: TableBorder.all(
                width: 0.5, borderRadius: BorderRadius.all(Radius.circular(5))),
            columns: [
              DataColumn(
                  label: Text(
                "${ApplicationLocalizations.of(context).translate(i18.common.CHARGE_HEAD)}",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                "${ApplicationLocalizations.of(context).translate(i18.common.CALC_TYPE)}",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                "${ApplicationLocalizations.of(context).translate(i18.common.BILLING_SLAB)}",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                "${ApplicationLocalizations.of(context).translate(i18.searchWaterConnection.CONNECTION_TYPE)}",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                "${ApplicationLocalizations.of(context).translate(i18.common.RATE_PERCENTAGE)}",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text("12312")),
                DataCell(Text("ABCD")),
                DataCell(Text("30")),
                DataCell(Text("WS")),
                DataCell(Text("10"))
              ]),
              DataRow(
                  color: MaterialStateProperty.resolveWith(getColor),
                  cells: [
                    DataCell(Text("12312")),
                    DataCell(Text("ABCD")),
                    DataCell(Text("20")),
                    DataCell(Text("WS")),
                    DataCell(Text("10"))
                  ]),
              DataRow(cells: [
                DataCell(Text("12312")),
                DataCell(Text("ABCD")),
                DataCell(Text("10")),
                DataCell(Text("WS")),
                DataCell(Text("10"))
              ]),
              DataRow(
                  color: MaterialStateProperty.resolveWith(getColor),
                  cells: [
                    DataCell(Text("12312")),
                    DataCell(Text("ABCD")),
                    DataCell(Text("20")),
                    DataCell(Text("WS")),
                    DataCell(Text("10"))
                  ]),
              DataRow(cells: [
                DataCell(Text("12312")),
                DataCell(Text("ABCD")),
                DataCell(Text("40")),
                DataCell(Text("WS")),
                DataCell(Text("10"))
              ]),
              DataRow(
                  color: MaterialStateProperty.resolveWith(getColor),
                  cells: [
                    DataCell(Text("12312")),
                    DataCell(Text("ABCD")),
                    DataCell(Text("25")),
                    DataCell(Text("WS")),
                    DataCell(Text("10"))
                  ]),
            ]),
      );
    }
    return Padding(
      padding: constraints.maxWidth > 760
          ? const EdgeInsets.all(20.0)
          : const EdgeInsets.all(8.0),
      child: DataTable(
          border: TableBorder.all(
              width: 0.5, borderRadius: BorderRadius.all(Radius.circular(5))),
          columns: [
            DataColumn(
                label: Text(
              "${ApplicationLocalizations.of(context).translate(i18.common.CHARGE_HEAD)}",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              "${ApplicationLocalizations.of(context).translate(i18.common.CALC_TYPE)}",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              "${ApplicationLocalizations.of(context).translate(i18.searchWaterConnection.CONNECTION_TYPE)}",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              "${ApplicationLocalizations.of(context).translate(i18.common.RATE_PERCENTAGE)}",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text("12312")),
              DataCell(Text("ABCD")),
              DataCell(Text("WS")),
              DataCell(Text("10"))
            ]),
            DataRow(color: MaterialStateProperty.resolveWith(getColor), cells: [
              DataCell(Text("12312")),
              DataCell(Text("ABCD")),
              DataCell(Text("WS")),
              DataCell(Text("10"))
            ]),
            DataRow(cells: [
              DataCell(Text("12312")),
              DataCell(Text("ABCD")),
              DataCell(Text("WS")),
              DataCell(Text("10"))
            ]),
            DataRow(color: MaterialStateProperty.resolveWith(getColor), cells: [
              DataCell(Text("12312")),
              DataCell(Text("ABCD")),
              DataCell(Text("WS")),
              DataCell(Text("10"))
            ]),
            DataRow(cells: [
              DataCell(Text("12312")),
              DataCell(Text("ABCD")),
              DataCell(Text("WS")),
              DataCell(Text("10"))
            ]),
          ]),
    );
  }
}
