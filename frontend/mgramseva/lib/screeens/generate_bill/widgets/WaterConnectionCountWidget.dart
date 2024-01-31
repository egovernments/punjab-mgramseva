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
      padding: EdgeInsets.only(left: 20, right: MediaQuery.of(context).size.width * 0.2),
      width: MediaQuery.of(context).size.width,
      child: Consumer<ReportsProvider>(
        builder: (_, provider, child) {
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("LAST BILL CYCLE"),
                Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                  child:Column(
                    children:[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Last Bill Cycle Month"),
                          Text("Consumer Count"),

                        ],
                      ),
                      ...?provider.waterConnectionCount?.map((e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormats.getMonthAndYearFromDateTime(DateTime.fromMillisecondsSinceEpoch(e.taxperiodto!))),
                          Text(e.count.toString()),
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
