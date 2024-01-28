import 'package:flutter/cupertino.dart';
import 'package:mgramseva/providers/reports_provider.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:provider/provider.dart';

class WaterConnectionCountWidget extends StatefulWidget {
  @override
  _WaterConnectionCountWidgetState createState() =>
      _WaterConnectionCountWidgetState();
}

class _WaterConnectionCountWidgetState
    extends State<WaterConnectionCountWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<ReportsProvider>(
        builder: (_, provider, child) {
          return Container(
            child: Row(
              children: [
                Text("LAST BILL CYCLE"),
                Container(
                  child:Column(
                    children:[
                      Row(
                        children: [
                          Text("Consumer Count"),
                          Text("Last Bill Cycle Month"),
                        ],
                      ),
                      ...?provider.waterConnectionCount?.map((e) => Row(
                        children: [
                          Text(e.count.toString()),
                          Text(DateFormats.getMonthAndYearFromDateTime(DateTime.fromMillisecondsSinceEpoch(e.taxperiodto!))),
                        ],
                      )).toList(),
                    ]
                  )
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
