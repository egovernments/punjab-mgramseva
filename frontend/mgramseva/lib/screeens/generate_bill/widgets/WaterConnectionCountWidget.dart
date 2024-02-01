import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/reports/WaterConnectionCount.dart';
import 'package:mgramseva/providers/reports_provider.dart';
import 'package:mgramseva/utils/constants/i18_key_constants.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:provider/provider.dart';

import '../../../utils/localization/application_localizations.dart';
import '../../../widgets/label_text.dart';

class WaterConnectionCountWidget extends StatefulWidget {
  @override
  _WaterConnectionCountWidgetState createState() =>
      _WaterConnectionCountWidgetState();
}

class _WaterConnectionCountWidgetState
    extends State<WaterConnectionCountWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }
  afterViewBuild() {
    Provider.of<ReportsProvider>(context,listen: false)
      ..getWaterConnectionsCount();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
              LabelText(
                  '${"${ApplicationLocalizations.of(context).translate(i18.common.WS_REPORTS_WATER_CONNECTION_COUNT)}"}'),
              LayoutBuilder(builder: (context, constraints) {
    if (constraints.maxWidth > 760) {
      return Container(
        margin:
        const EdgeInsets.only(top: 5.0, bottom: 5, right: 20, left: 20),
        child: Consumer<ReportsProvider>(
          builder: (_, provider, child) {
            return provider.waterConnectionCount==null?SizedBox():Container(
                child: Column(
                  children: [
                    provider.waterConnectionCount?.waterConnectionsDemandGenerated?.length==0?SizedBox():Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 18, bottom: 3),
                            child: Text("${ApplicationLocalizations.of(context).translate(i18.common.LAST_BILL_CYCLE_DEMAND_GENERATED)}")),
                        Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            padding: EdgeInsets.only(top: 18, bottom: 3),
                            child:consumerCountTableMonthWise(provider.waterConnectionCount?.waterConnectionsDemandGenerated,constraints.maxWidth),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    provider.waterConnectionCount?.waterConnectionsDemandNotGenerated?.length==0?SizedBox():Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 18, bottom: 3),
                            child: Text("${ApplicationLocalizations.of(context).translate(i18.common.LAST_BILL_CYCLE_DEMAND_NOT_GENERATED)}")),
                        Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            padding: EdgeInsets.only(top: 18, bottom: 3),
                            child:consumerCountTableMonthWise(provider.waterConnectionCount?.waterConnectionsDemandNotGenerated,constraints.maxWidth),
                        )
                      ],
                    ),
                  ],
                )
            );
          },
        ),
      );
    }
    else{
      return Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 5, right: 8, left: 8),
        child: Consumer<ReportsProvider>(
          builder: (_, provider, child) {
            return provider.waterConnectionCount==null?SizedBox():Container(
                child: Column(
                  children: [
                    provider.waterConnectionCount?.waterConnectionsDemandGenerated?.length==0?SizedBox():Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${ApplicationLocalizations.of(context).translate(i18.common.LAST_BILL_CYCLE_DEMAND_GENERATED)}"),
                        SizedBox(height: 10,),
                        consumerCountTableMonthWise(provider.waterConnectionCount?.waterConnectionsDemandGenerated,constraints.maxWidth),
                      ],
                    ),
                    SizedBox(height: 20,),
                    provider.waterConnectionCount?.waterConnectionsDemandNotGenerated?.length==0?SizedBox():Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${ApplicationLocalizations.of(context).translate(i18.common.LAST_BILL_CYCLE_DEMAND_NOT_GENERATED)}"),
                        SizedBox(height: 10,),
                        consumerCountTableMonthWise(provider.waterConnectionCount?.waterConnectionsDemandNotGenerated,constraints.maxWidth),
                      ],
                    ),
                  ],
                )
            );
          },
        ),
      );
    }

                }
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget consumerCountTableMonthWise(List<WaterConnectionCount>? waterConnectionCount,double width){
    if(width>760){
      return consumerCountTableMonthWiseWidget(waterConnectionCount);
    }else{
      return
        FittedBox(
          child: consumerCountTableMonthWiseWidget(waterConnectionCount),
        );
    }

  }
  Widget consumerCountTableMonthWiseWidget(List<WaterConnectionCount>? waterConnectionCount){
    return
      DataTable(
        border: TableBorder.all(
            width: 0.5, borderRadius: BorderRadius.all(Radius.circular(5))),
        columns:[
          DataColumn(label: FittedBox(child: Text("${ApplicationLocalizations.of(context).translate(i18.common.LAST_BILL_CYCLE_MONTH)}"))),
          DataColumn(label: FittedBox(child: Text("${ApplicationLocalizations.of(context).translate(i18.common.CONSUMER_COUNT)}")))
        ],
        rows: [
          ...?waterConnectionCount?.map((e) => DataRow(
            cells: [
              DataCell(Text(DateFormats.getMonthAndYearFromDateTime(DateTime.fromMillisecondsSinceEpoch(e.taxperiodto!))),),
              DataCell(Text(e.count.toString()),),
            ],
          )).toList(),
        ],
      );
  }
}
