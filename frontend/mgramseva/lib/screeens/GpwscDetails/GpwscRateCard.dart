import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:provider/provider.dart';
import '../../providers/ifix_hierarchy_provider.dart';
import '../../utils/Locilization/application_localizations.dart';
import '../../widgets/LabelText.dart';
import 'GpwscCard.dart';

class GpwscRateCard extends StatelessWidget {
  final String rateType;

  const GpwscRateCard({Key? key, required this.rateType}) : super(key: key);

  Color getColor(Set<MaterialState> states) {
    return Colors.grey.shade200;
  }
  List<Widget> getTableTitle(context,constraints,String rateType){
    return [
      LabelText(
          "${ApplicationLocalizations.of(context).translate(i18.dashboard.GPWSC_RATE_INFO)}"),
      Padding(
        padding: (constraints.maxWidth > 760 ? const EdgeInsets.all(15.0) : const EdgeInsets.all(8.0)),
        child: Text(
          "(${ApplicationLocalizations.of(context).translate(rateType)})",
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.left,
        ),
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GpwscCard(
        children: [
          constraints.maxWidth < 760?Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: getTableTitle(context,constraints,rateType),
          ):Row(
            children: getTableTitle(context,constraints,rateType),
          ),
          Consumer<IfixHierarchyProvider>(
              key: key,
              builder: (_, departmentProvider, child) {
                return _getRateCard(
                    rateType, departmentProvider, context, constraints);
              })
        ],
      );
    });
  }

  Widget _getRateCard(String type, IfixHierarchyProvider ifixHierarchyProvider,
      context, BoxConstraints constraints) {
    List<DataRow> getMeteredRows() {
      List<DataRow> rows = [];
      ifixHierarchyProvider.wcBillingSlabs!.wCBillingSlabs
          ?.where(
              (element) => element.connectionType?.compareTo("Metered") == 0)
          .forEach((e) => {
                e.slabs?.forEach((slabs) => rows.add(DataRow(cells: [
                      DataCell(Text(ApplicationLocalizations.of(context)
                          .translate(i18.billDetails.WATER_CHARGES_10101))),
                      DataCell(Text("${e.calculationAttribute}")),
                      DataCell(Text("${slabs.from}-${slabs.to}")),
                      DataCell(Text("${e.buildingType}")),
                      DataCell(Text("${slabs.charge}"))
                    ])))
              });
      return rows;
    }

    if (type.compareTo("Metered") == 0) {
      return Padding(
        padding: constraints.maxWidth > 760
            ? const EdgeInsets.all(20.0)
            : const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
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
              rows: getMeteredRows()),
        ),
      );
    }
    return Padding(
      padding: constraints.maxWidth > 760
          ? const EdgeInsets.all(20.0)
          : const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
            rows: ifixHierarchyProvider.wcBillingSlabs!.wCBillingSlabs.where((element) => element.connectionType?.compareTo("Metered")!=0)
                .map((slab) => DataRow(cells: [
              DataCell(Text("Water Charges-10101")),
              DataCell(Text("${slab.calculationAttribute}")),
              DataCell(Text("${slab.buildingType}")),
              DataCell(Text("${slab.minimumCharge}"))
            ]))
                .toList()),
      ),
    );
  }
}
